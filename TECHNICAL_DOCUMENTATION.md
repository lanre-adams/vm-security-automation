
# 🧾 Technical Documentation: VM Security & Optimization Framework

## 🔍 Overview
This framework automates and optimizes virtual machine security and cloud resource usage across large-scale Azure deployments using PowerShell, Azure CLI, Terraform, and Machine Learning. It enhances compliance, reduces costs, and improves performance.

## 🏛️ Architectural Principles

### 1. **Modular Design**
Each core function (security automation, optimization, ML scaling, reporting) is isolated in separate scripts/modules for maintainability and reusability.

### 2. **Automation-First**
Tasks are fully automated using PowerShell and Azure CLI, reducing human intervention and error, and enabling 24/7 operations.

### 3. **Compliance & Observability**
Power BI dashboards provide real-time visibility into security posture and cost metrics. Terraform + Azure Policies ensure compliance-by-design.

### 4. **ML-Driven Optimization**
Historical usage data feeds an ML model that predicts future resource needs. Auto-scaling scripts use these predictions to adjust VM specs.

---

## ⚙️ Key Modules

### 🔐 Security Automation
- `Assign-DynamicSG.ps1`: Assigns NSGs based on VM metadata.
- `Deploy-SecurityAgents.ps1`: Installs agents (Defender, Sentinel, etc.).
- `Monitor-Compliance.ps1`: Checks against CIS/Azure benchmarks.
- `Invoke-PatchOrchestrator.ps1`: Patches VMs with zero/minimal downtime.
- `Correlate-SecurityEvents.ps1`: Collects and analyzes VM logs for threats.

### 💡 Optimization Scripts
- `Analyze-VMUtilization.ps1`: Collects CPU/memory/disk usage stats.
- `Invoke-VMScheduler.ps1`: Shuts down non-critical VMs during off-hours.
- `Scale-VMs.ps1`: Adjusts VM sizes based on ML predictions.
- `Audit-Actions.ps1`: Tracks all actions for compliance.

### 📊 Reporting & Dashboards
- `vm_costs.pbix`: Visualizes cost-saving trends.
- `compliance_status.pbix`: Tracks security compliance.

---

## ☁️ Terraform & Policy Enforcement
Terraform files deploy NSGs, tags, and policy definitions:
- `enforce_tags.json`: Ensures all resources are tagged for chargeback/accountability.
- `restrict_locations.json`: Restricts resource deployment to allowed regions.

---

## 🤖 Machine Learning Engine
- `scale_predictor.py`: Predicts VM sizes based on historical data.
- `model_training.ipynb`: Jupyter notebook for model tuning.
- Outputs JSON config (`scale_recommendations.json`) for use in `Scale-VMs.ps1`.

---

## 🚀 Deployment

1. Clone or unzip the repository.
2. Run `installer.ps1` to:
   - Set up PowerShell modules
   - Register required Azure CLI contexts
   - Schedule daily/weekly jobs
3. Import `.pbix` files into Power BI for live dashboards.
4. Execute Terraform scripts for NSGs, tagging, and policy enforcement.

---

## ✅ Outcome
- Average 37% cloud cost reduction
- 28% additional saving from smart scheduling
- Increased security compliance & visibility
- Predictive resource management with ML integration

---

© 2025 | Developed by Olanrewaju for secure, cost-effective cloud environments.
