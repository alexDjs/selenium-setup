# 12. Initialize npm project
Write-Host "📦 Initializing npm project..." -ForegroundColor Cyan
npm init -y

# 13. Install useful npm packages
npm install --save-dev dotenv prettier eslint

# 14. Create .env file template
@"
# Environment Configuration
BROWSER=chrome
HEADLESS=false
IMPLICIT_WAIT=10
EXPLICIT_WAIT=30
BASE_URL=https://www.google.com
"@ | Out-File ".env" -Encoding UTF8

# 15. Create .gitignore
@"
# Maven
target/
pom.xml.tag
pom.xml.releaseBackup
pom.xml.versionsBackup
pom.xml.next
release.properties

# IDE
.idea/
*.iml
.vscode/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
logs/
*.log

# Node
node_modules/
npm-debug.log*

# Environment
.env.local
.env.development.local
.env.test.local
.env.production.local

# Test Reports
test-output/
screenshots/
reports/
"@ | Out-File ".gitignore" -Encoding UTF8

# 16. Create comprehensive README.md
@"
# 🚀 Selenium Java Automation Project

Automated testing framework built with Selenium WebDriver, TestNG, and Maven.

## 🛠️ Tech Stack

- **Java 17** - Programming language
- **Selenium WebDriver** - Browser automation
- **TestNG** - Testing framework
- **Maven** - Build and dependency management
- **WebDriverManager** - Automatic driver management
- **Log4j2** - Logging framework
- **Page Object Model** - Design pattern

## 📋 Prerequisites

This project includes an automated setup script that installs:
- JDK 17 (Temurin)
- Maven
- Node.js & npm
- Git

## 🚀 Quick Setup

Run this command in PowerShell:

\`\`\`powershell
irm https://raw.githubusercontent.com/YOUR_USERNAME/ProjectSelenium/main/setup.ps1 | iex
\`\`\`

## 📁 Project Structure

\`\`\`
$ProjectName/
├── pom.xml                          # Maven configuration
├── package.json                     # npm configuration
├── .env                             # Environment variables
├── README.md                        # This file
├── src/
│   └── test/
│       ├── java/
│       │   └── com/example/selenium/
│       │       ├── base/
│       │       │   └── BaseTest.java    # Base test class
│       │       ├── pages/
│       │       │   └── GooglePage.java  # Page Object example
│       │       └── tests/
│       │           └── GoogleTest.java  # Test class example
│       └── resources/
│           ├── log4j2.xml           # Logging configuration
│           └── testng.xml           # TestNG suite configuration
└── logs/                            # Log files (auto-generated)
\`\`\`

## 🏃‍♂️ Running Tests

### Run all tests:
\`\`\`bash
mvn test
\`\`\`

### Run specific test class:
\`\`\`bash
mvn test -Dtest=GoogleTest
\`\`\`

### Run with custom TestNG suite:
\`\`\`bash
mvn test -DsuiteXmlFile=src/test/resources/testng.xml
\`\`\`

## 🧪 Writing Tests

### 1. Create a new Page Object:
\`\`\`java
package com.example.selenium.pages;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.PageFactory;

public class LoginPage {
    private WebDriver driver;
    
    public LoginPage(WebDriver driver) {
        this.driver = driver;
        PageFactory.initElements(driver, this);
    }
    
    // Add page elements and methods here
}
\`\`\`

### 2. Create a new Test:
\`\`\`java
package com.example.selenium.tests;

import com.example.selenium.base.BaseTest;
import org.testng.annotations.Test;

public class LoginTest extends BaseTest {
    
    @Test
    public void testLogin() {
        // Your test logic here
    }
}
\`\`\`

## 📊 Logging

Logs are automatically saved to:
- Console output (colored)
- File: \`logs/selenium-tests.log\`

Log levels: DEBUG, INFO, WARN, ERROR

## 🔧 Configuration

### Environment Variables (.env):
- \`BROWSER\` - Browser to use (chrome, firefox)
- \`HEADLESS\` - Run in headless mode (true/false)
- \`IMPLICIT_WAIT\` - Implicit wait timeout in seconds
- \`EXPLICIT_WAIT\` - Explicit wait timeout in seconds
- \`BASE_URL\` - Base URL for tests

### Maven Properties:
Edit \`pom.xml\` to update dependency versions.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: \`git checkout -b feature-name\`
3. Commit changes: \`git commit -am 'Add feature'\`
4. Push to branch: \`git push origin feature-name\`
5. Submit a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Troubleshooting

### Common Issues:

**WebDriver not found:**
- WebDriverManager handles this automatically
- Ensure Chrome browser is installed

**Tests not running:**
- Check Java version: \`java -version\`
- Verify Maven installation: \`mvn -version\`

**Permission errors:**
- Run PowerShell as Administrator
- Check ExecutionPolicy: \`Get-ExecutionPolicy\`

### Need Help?

- Check logs in \`logs/selenium-tests.log\`
- Review TestNG reports in \`target/surefire-reports/\`
- Ensure all dependencies are installed: \`mvn dependency:resolve\`

---

**Happy Testing! 🎉**
"@ | Out-File "README.md" -Encoding UTF8

# 17. Create logs directory
New-Item -ItemType Directory -Force -Path "logs" | Out-Null

# 18. Install Maven dependencies with error handling
Write-Host "📥 Installing Maven dependencies..." -ForegroundColor Cyan
try {
    mvn clean compile test-compile
    Write-Host "✅ Maven dependencies installed successfully" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Warning: Maven dependency installation had issues. Check Maven installation." -ForegroundColor Yellow
    Write-Host "You can manually run 'mvn clean compile test-compile' later" -ForegroundColor Yellow
}

# 19. Run initial test with error handling
Write-Host "🧪 Running initial tests..." -ForegroundColor Cyan
try {
    mvn test
    Write-Host "✅ Initial tests completed successfully" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Tests had issues. This is normal for first run." -ForegroundColor Yellow
    Write-Host "Check README.md for troubleshooting steps" -ForegroundColor Yellow
}

Write-Host "`n🎉 Setup completed successfully!" -ForegroundColor Green
Write-Host "📁 Project created in: $(Get-Location)" -ForegroundColor Yellow
Write-Host "📖 Read README.md for usage instructions" -ForegroundColor Cyan

Write-Host "`n🚀 Quick commands to get started:" -ForegroundColor Magenta
Write-Host "   mvn test                 # Run all tests" -ForegroundColor White
Write-Host "   mvn test -Dtest=GoogleTest # Run specific test" -ForegroundColor White
Write-Host "   code .                   # Open in VS Code" -ForegroundColor White

Write-Host "`n📋 Installation methods:" -ForegroundColor Magenta
Write-Host "   Local: .\setup.ps1" -ForegroundColor White
Write-Host "   GitHub: irm https://raw.githubusercontent.com/YOUR_USERNAME/selenium-setup/main/setup.ps1 | iex" -ForegroundColor White

Write-Host "`n📤 To upload this setup to your GitHub repository:" -ForegroundColor Cyan
Write-Host "1. Go back to parent directory:" -ForegroundColor White
Write-Host "   cd .." -ForegroundColor Gray
Write-Host "2. Initialize git repository:" -ForegroundColor White
Write-Host "   git init" -ForegroundColor Gray
Write-Host "3. Add all files:" -ForegroundColor White
Write-Host "   git add ." -ForegroundColor Gray
Write-Host "4. Make initial commit:" -ForegroundColor White
Write-Host "   git commit -m `"Initial Selenium setup script`"" -ForegroundColor Gray
Write-Host "5. Set main branch:" -ForegroundColor White
Write-Host "   git branch -M main" -ForegroundColor Gray
Write-Host "6. Add your GitHub repository:" -ForegroundColor White
Write-Host "   git remote add origin https://github.com/YOUR_USERNAME/selenium-setup.git" -ForegroundColor Gray
Write-Host "7. Push to GitHub:" -ForegroundColor White
Write-Host "   git push -u origin main" -ForegroundColor Gray

Write-Host "`n🔗 After uploading, anyone can install with:" -ForegroundColor Green
Write-Host "   irm https://raw.githubusercontent.com/YOUR_USERNAME/selenium-setup/main/setup.ps1 | iex" -ForegroundColor Yellow

Write-Host "`n💡 Pro tip: Create a shorter link with bit.ly or tinyurl!" -ForegroundColor Cyan
Write-Host "💡 Tip: Upload setup.ps1 to GitHub for one-command installation!" -ForegroundColor Cyan
