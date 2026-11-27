using System;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

internal sealed class Launcher : Form
{
    private readonly Label status = new Label();
    private readonly Button open = new Button();
    private readonly Button close = new Button();
    private readonly StringBuilder log = new StringBuilder();
    private Process server;
    private string folder;
    private string address;
    private bool preparing = true;
    private bool stopRequested;
    private readonly bool autoOpen;

    [STAThread]
    private static void Main(string[] args)
    {
        Application.EnableVisualStyles();
        Application.SetCompatibleTextRenderingDefault(false);
        Application.Run(new Launcher(!args.Contains("--sem-navegador")));
    }

    private Launcher(bool autoOpen)
    {
        this.autoOpen = autoOpen;
        Text = "Busca APPA";
        ClientSize = new Size(485, 170);
        StartPosition = FormStartPosition.CenterScreen;
        FormBorderStyle = FormBorderStyle.FixedDialog;
        MaximizeBox = false;
        Font = new Font("Segoe UI", 10);
        BackColor = Color.FromArgb(250, 251, 248);
        var title = new Label { Text = "Busca APPA", AutoSize = true, Left = 20, Top = 16,
            Font = new Font("Segoe UI", 19, FontStyle.Bold), ForeColor = Color.FromArgb(23, 88, 61) };
        status.SetBounds(20, 58, 445, 48);
        status.Text = "Preparando o motor e o corpus offline…";
        open.Text = "Abrir busca";
        open.SetBounds(20, 117, 113, 32);
        open.Enabled = false;
        open.Click += (sender, e) => Abrir();
        close.Text = "Encerrar";
        close.SetBounds(146, 117, 113, 32);
        close.Click += (sender, e) => Close();
        Controls.AddRange(new Control[] { title, status, open, close });
        Shown += async (sender, e) => await Iniciar();
        FormClosing += (sender, e) => {
            if (preparing) {
                e.Cancel = true;
                stopRequested = true;
                status.Text = "Encerrando…";
            } else {
                Limpar();
            }
        };
    }

    private async Task Iniciar()
    {
        try {
            string temp = Path.GetTempPath();
            var drive = new DriveInfo(Path.GetPathRoot(temp));
            if (drive.AvailableFreeSpace < 500L * 1024 * 1024)
                temp = AppDomain.CurrentDomain.BaseDirectory;
            folder = Path.Combine(temp, "Busca-APPA-" + Guid.NewGuid().ToString("N"));
            await Task.Run(() => {
                Directory.CreateDirectory(folder);
                using (Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("appa.zip"))
                using (var archive = new ZipArchive(stream, ZipArchiveMode.Read))
                    archive.ExtractToDirectory(folder);
            });
            if (stopRequested) return;
            status.Text = "Carregando o índice dos clubes…";
            int port;
            var listener = new TcpListener(IPAddress.Loopback, 0);
            listener.Start();
            try { port = ((IPEndPoint)listener.LocalEndpoint).Port; }
            finally { listener.Stop(); }
            address = "http://127.0.0.1:" + port + "/";
            string rHome = Path.Combine(folder, "R");
            string project = Path.Combine(folder, "pi3");
            var start = new ProcessStartInfo {
                FileName = Path.Combine(rHome, "bin", "x64", "Rterm.exe"),
                Arguments = "--vanilla --slave --file=\"" + Path.Combine(project, "entregas", "entrega-final", "motor", "iniciar.R") + "\"",
                WorkingDirectory = project,
                UseShellExecute = false,
                CreateNoWindow = true,
                RedirectStandardOutput = true,
                RedirectStandardError = true
            };
            start.EnvironmentVariables["R_HOME"] = rHome;
            start.EnvironmentVariables["R_LIBS"] = Path.Combine(rHome, "library");
            start.EnvironmentVariables["R_LIBS_USER"] = Path.Combine(folder, "sem-biblioteca-externa");
            start.EnvironmentVariables["R_LIBS_SITE"] = "";
            start.EnvironmentVariables["APPA_PORT"] = port.ToString();
            start.EnvironmentVariables["TMP"] = folder;
            start.EnvironmentVariables["TEMP"] = folder;
            server = new Process { StartInfo = start };
            server.OutputDataReceived += Registrar;
            server.ErrorDataReceived += Registrar;
            server.Start();
            server.BeginOutputReadLine();
            server.BeginErrorReadLine();

            var clock = Stopwatch.StartNew();
            while (!stopRequested && clock.Elapsed < TimeSpan.FromSeconds(60)) {
                if (server.HasExited) throw new InvalidOperationException("O motor encerrou durante a abertura.");
                if (await Task.Run(() => Pronto(address))) {
                    status.Text = "Busca pronta. Mantenha esta janela aberta durante a apresentação.";
                    open.Enabled = true;
                    if (autoOpen) Abrir();
                    return;
                }
                await Task.Delay(300);
            }
            if (!stopRequested) throw new TimeoutException("O navegador não recebeu resposta do motor.");
        } catch (Exception ex) {
            if (!stopRequested) {
                status.Text = "Não foi possível iniciar a busca.";
                string detail;
                lock (log) detail = log.ToString();
                if (autoOpen) MessageBox.Show(this, ex.Message + Environment.NewLine + detail,
                    "Busca APPA", MessageBoxButtons.OK, MessageBoxIcon.Error);
                else status.Text = ex.Message;
            }
            Limpar();
        } finally {
            preparing = false;
            if (stopRequested) Close();
        }
    }

    private void Registrar(object sender, DataReceivedEventArgs e)
    {
        if (e.Data == null) return;
        lock (log) {
            log.AppendLine(e.Data);
            if (log.Length > 2800) log.Remove(0, log.Length - 2800);
        }
    }

    private static bool Pronto(string url)
    {
        try {
            var request = (HttpWebRequest)WebRequest.Create(url);
            request.Timeout = 1000;
            request.Proxy = null;
            using (var response = (HttpWebResponse)request.GetResponse()) return response.StatusCode == HttpStatusCode.OK;
        } catch (WebException) { return false; }
    }

    private void Abrir()
    {
        try { Process.Start(address); }
        catch (Exception) { status.Text = "Abra no navegador: " + address; }
    }

    private void Limpar()
    {
        if (server != null) {
            try { if (!server.HasExited) { server.Kill(); server.WaitForExit(2500); } }
            catch (InvalidOperationException) { }
            server.Dispose();
            server = null;
        }
        try { if (folder != null && Directory.Exists(folder)) Directory.Delete(folder, true); }
        catch (IOException) { }
        catch (UnauthorizedAccessException) { }
    }
}
