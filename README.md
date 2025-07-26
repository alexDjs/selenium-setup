@"
# 🚀 Selenium Java Auto-Setup

Automatic installer for creating ready-to-use Selenium Java projects on Windows 11. One command - and you have a complete test automation environment!

## ⚡ Quick Start

Run this command in PowerShell (as Administrator):

\`\`\`powershell
irm https://raw.githubusercontent.com/YOUR_USERNAME/selenium-setup/main/setup.ps1 | iex
\`\`\`

**Result:** Ready Maven project with configured Selenium in 5-10 minutes!

## 🛠️ What gets automatically installed

- ☕ **JDK 17** (Temurin) - stable Java
- 📦 **Maven** - dependency management
- 🟢 **Node.js & npm** - for integrations
- 📄 **Git** - version control system
- 🍫 **Chocolatey** - Windows package manager

## 📦 What gets created in the project

- ✅ **Selenium WebDriver** with latest versions
- ✅ **TestNG** for powerful testing
- ✅ **WebDriverManager** - automatic driver management
- ✅ **Log4j2** - professional logging
- ✅ **Page Object Model** - ready examples
- ✅ **Colored logs** and reports
- ✅ **Ready tests** for Google

## 📁 Project Structure

\`\`\`
selenium-automation-project/
├── pom.xml                          # Maven configuration
├── package.json                     # npm dependencies
├── .env                             # Environment variables
├── src/test/java/com/example/selenium/
│   ├── base/BaseTest.java           # Base test class
│   ├── pages/GooglePage.java        # Page Object example
│   └── tests/GoogleTest.java        # Ready tests
└── src/test/resources/
    ├── log4j2.xml                   # Logging configuration
    └── testng.xml                   # TestNG configuration
\`\`\`

## 🏃‍♂️ How to run tests

After installation:

\`\`\`bash
cd selenium-automation-project
mvn test
\`\`\`

**Or run specific test:**

\`\`\`bash
mvn test -Dtest=GoogleTest
\`\`\`

## 🎯 System Requirements

- ✅ Windows 11 (x64)
- ✅ PowerShell 5.1+
- ✅ Internet access
- ✅ Administrator rights (for software installation)
- ✅ Chrome browser (for WebDriver)

## 🔧 Troubleshooting

### PowerShell execution policy issues:
\`\`\`powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
\`\`\`

### If Chocolatey won't install:
\`\`\`powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
\`\`\`

### If Maven not found:
\`\`\`bash
refreshenv
# or restart PowerShell
\`\`\`

### If tests won't run:
- Make sure Chrome is installed
- Check Java: \`java -version\`
- Check Maven: \`mvn -version\`

## 🎨 Project Features

- 🎯 **WebDriverManager** - automatically downloads required drivers
- 🏗️ **Page Object Pattern** - clean test architecture
- 📊 **Colored logs** - beautiful console output
- 📝 **Detailed logging** - all actions are recorded
- ⚙️ **Settings via .env** - easy configuration
- 🧪 **TestNG** - powerful testing capabilities

## 🚀 What's next?

After installation you can:

1. **Write new tests** - use ready examples
2. **Add Page Objects** - extend the architecture
3. **Configure environment** - edit \`.env\` file
4. **Integrate with CI/CD** - ready for Jenkins/GitHub Actions

## 💡 Usage Examples

### Create new Page Object:
\`\`\`java
@FindBy(id = "username")
private WebElement usernameField;

public void enterUsername(String username) {
    usernameField.sendKeys(username);
}
\`\`\`

### Create new test:
\`\`\`java
@Test
public void testLogin() {
    LoginPage loginPage = new LoginPage(driver);
    loginPage.login("user", "password");
    Assert.assertTrue(loginPage.isLoggedIn());
}
\`\`\`

## 📄 License

MIT License - use freely in any projects!

## 🤝 Want to help the project?

1. ⭐ Star the repository
2. 🐛 Report bugs via Issues
3. 💡 Suggest improvements
4. 🔄 Make Pull Requests

## 📞 Support

- 📝 Create Issue for questions
- 📖 Read documentation in code
- 🔍 Check logs in \`logs/selenium-tests.log\`

---

**⚡ Made for quick test automation setup!**
**💪 Save time on configuration - focus on tests!**
"@ | Out-File "README.md" -Encoding UTF8
```
