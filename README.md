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


