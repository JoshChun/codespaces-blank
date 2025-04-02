# FullStack-DevOps

## Steps to Define Terraform Templates, GitHub Actions Workflows, and Deployment to Azure

1. **Define Terraform Templates:**
    - Created the following Terraform configuration files in the `terraform/` directory:
        - `backend.tf`
        - `main.tf`
        - `output.tf`
        - `providers.tf`
        - `terraform.tfvars`
        - `variables.tf`
    - Initialized the Terraform configuration with `terraform init`.
    - Validated the Terraform configuration with `terraform validate`.
    - Planned the Terraform deployment with `terraform plan`.
    - Applied the Terraform configuration with `terraform apply`.

2. **Define GitHub Actions Workflows:**
    - Created a test GitHub Actions workflow for Azure CLI login in `.github/workflows/azure-cli-test.yml`.
    - Created a GitHub Actions workflow for Terraform deployment in `.github/workflows/terraform-deploy.yml`.

3. **Deployment to Azure:**
    - The GitHub Actions workflows are configured to run on push events to the `main` branch.
    - The workflows perform Azure CLI login using OpenID Connect and execute Terraform commands to deploy the infrastructure to Azure.

4. **Install Node Exporter on the Linux VM:**
    - Installed Node Exporter on the Linux VM to expose metrics.
    - Created and enabled Node Exporter as a Service.

    1. Download & Install
    ```
    wget https://github.com/prometheus/node_exporter/releases/download/v<VERSION>/node_exporter-<VERSION>.<OS>-<ARCH>.tar.gz
    tar xvfz node_exporter-*.*-*.tar.gz
    sudo mv node_exporter-*.*-*/node_exporter /usr/local/bin
    ```
    2. Create a Systemd Service
    ```
    echo "[Unit]
    Description=Node Exporter
    After=network.target

    [Service]
    User=root
    ExecStart=/usr/local/bin/node_exporter
    Restart=always

    [Install]
    WantedBy=multi-user.target" | sudo tee /etc/systemd/system/node_exporter.service
    ```
    3. Start & Enable Node Exporter
    ```
    sudo systemctl daemon-reload
    sudo systemctl enable --now node_exporter
    curl http://localhost:9100/metrics
    ```

5. **Install Prometheus on the Linux VM:**
    - Installed Prometheus on the Linux VM to collect and store metrics.
    - Created and enabled Prometheus as a Service.

    1. Download & Install
    ```
    wget https://github.com/prometheus/prometheus/releases/download/v<VERSION>/prometheus-<VERSION>.linux-amd64.tar.gz
    tar xvfz prometheus-*.tar.gz
    sudo mv prometheus-*/prometheus /usr/local/bin/
    sudo mv prometheus-*/promtool /usr/local/bin/
    sudo mv prometheus-*/prometheus.yml /etc/prometheus/
    sudo mv prometheus-*/consoles /etc/prometheus/
    sudo mv prometheus-*/console_libraries /etc/prometheus/
    ```
    2. Add Node Exporter as a scrape target
    Edit the config file /etc/prometheus/prometheus.yml:
    ```
    global:
        scrape_interval: 15s  # Collect metrics every 15 seconds

    scrape_configs:
        - job_name: "node_exporter"
            static_configs:
            - targets: ["localhost:9100"]  # Node Exporter on this VM

    ```
    3. Create a Systemd Service
    ```
    echo "[Unit]
    Description=Prometheus
    After=network.target

    [Service]
    User=root
    ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus/
    Restart=always

    [Install]
    WantedBy=multi-user.target" | sudo tee /etc/systemd/system/prometheus.service
    ```
    3. Start & Enable Prometheus
    ```
    sudo systemctl daemon-reload
    sudo systemctl enable --now prometheus
    curl http://localhost:9090/metrics
    curl -s http://localhost:9090/api/v1/targets | jq
    ```

6. **Install Grafana on the Linux VM**
    1. Install Grafana from the APT repository 
    ```
    #Install pre-requisite packages
    sudo apt-get install -y apt-transport-https software-properties-common wget

    #Import the GPG key
    sudo mkdir -p /etc/apt/keyrings/
    wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

    #Add repository for stable releases
    echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

    # Updates the list of available packages
    sudo apt-get update

    # Install Grafana OSS
    sudo apt-get install grafana
    ```

    2. Start and Enable Grafana
    ```
    sudo systemctl start grafana-server
    sudo systemctl enable grafana-server
    sudo systemctl status grafana-server
    ```

    3. Access Grafana
    ```
    http://localhost:3000
    ```