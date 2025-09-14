# 📄 Write-up

## 🛠️ Tools & Services Used
- **GitHub** → Version control & branching strategy (`main`, `dev`).
- **Jenkins** → CI/CD automation with pipeline as code (`Jenkinsfile`).
- **Docker** → Containerization with multi-stage builds for lightweight images.
- **AWS ECR** → Private container registry for storing images.
- **AWS ECS (EC2 Launch Type)** → Orchestrator to run containers on EC2.
- **AWS EC2** → Compute instances for Jenkins & ECS tasks.
- **CloudWatch Logs** → Centralized logging from ECS tasks.

---

## ⚡ Challenges Faced & Solutions
1. **ECS Task Not Accessible**
   - *Problem*: Application container was running but not accessible from EC2 public IP.  
   - *Solution*: Ensured app was bound to `0.0.0.0`, exposed correct container port, and updated ECS task definition with `portMappings`.

3. **ECS Deployment with Jenkins**
   - *Problem*: ECS service wasn’t automatically picking new Docker images.  
   - *Solution*: Used `aws ecs register-task-definition` and `aws ecs update-service --force-new-deployment` in Jenkins pipeline.

---

## 🚀 Possible Improvements (If More Time)
- Implement **Terraform/CloudFormation** for Infrastructure as Code (IaC).
- Add **Application Load Balancer (ALB)** for high availability & scalability.
- Setup **Auto Scaling policies** for ECS tasks (CPU/memory-based).
- Add **Unit/Integration Tests** in pipeline for stronger CI validation.
- Use **Prometheus + Grafana** or **CloudWatch Dashboards** for advanced monitoring.
- Implement **Blue-Green / Canary Deployments** to minimize downtime.

---

✅ This task demonstrates a complete CI/CD workflow with modern DevOps practices while keeping the setup simple and cost-effective.
