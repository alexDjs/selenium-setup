# Selenium Java Project Auto-Setup Script for Windows 11
# Usage: irm https://raw.githubusercontent.com/YOUR_USERNAME/selenium-setup/main/setup.ps1 | iex

param(
    [string]$ProjectName = "selenium-automation-project"
)

Write-Host "🚀 Starting Selenium Java Project Setup..." -ForegroundColor Cyan
Write-Host "Project Name: $ProjectName" -ForegroundColor Yellow

# Function to check if command exists
function Test-CommandExists {
    param($command)
    try {
        Get-Command $command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

# 1. Check and install Chocolatey
if (-not (Test-CommandExists choco)) {
    Write-Host "📦 Installing Chocolatey..." -ForegroundColor Cyan
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    try {
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        refreshenv
        Write-Host "✅ Chocolatey installed successfully" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to install Chocolatey. Please install manually." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✅ Chocolatey already installed" -ForegroundColor Green
}

# 2. Install required software
$softwareList = @(
    @{name="JDK 17"; package="temurin17"},
    @{name="Maven"; package="maven"},
    @{name="Node.js"; package="nodejs"},
    @{name="Git"; package="git"}
)

foreach ($software in $softwareList) {
    Write-Host "☕ Installing $($software.name)..." -ForegroundColor Cyan
    try {
        choco install $software.package -y
        Write-Host "✅ $($software.name) installed successfully" -ForegroundColor Green
    } catch {
        Write-Host "⚠️ Warning: $($software.name) installation had issues" -ForegroundColor Yellow
    }
}

# Refresh environment variables
refreshenv

# 3. Create project directory
if (Test-Path $ProjectName) {
    Write-Host "⚠️ Directory $ProjectName already exists. Removing..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $ProjectName
}

New-Item -ItemType Directory -Path $ProjectName
Set-Location $ProjectName

# 4. Generate Maven project structure
Write-Host "🏗️ Creating Maven project structure..." -ForegroundColor Cyan
try {
    mvn archetype:generate `
        -DgroupId=com.example.selenium `
        -DartifactId=$ProjectName `
        -DarchetypeArtifactId=maven-archetype-quickstart `
        -DinteractiveMode=false
    
    Set-Location $ProjectName
    Write-Host "✅ Maven project structure created" -ForegroundColor Green
} catch {
    Write-Host "❌ Failed to create Maven project. Check Maven installation." -ForegroundColor Red
    exit 1
}

# Execute the rest of the setup by downloading and running additional scripts
Write-Host "🔄 Executing project structure creation..." -ForegroundColor Cyan

# 5. Create enhanced pom.xml
Write-Host "📝 Creating enhanced pom.xml..." -ForegroundColor Cyan
@"
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.example.selenium</groupId>
    <artifactId>$ProjectName</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>
    
    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <selenium.version>4.15.0</selenium.version>
        <testng.version>7.8.0</testng.version>
        <webdrivermanager.version>5.6.2</webdrivermanager.version>
        <log4j.version>2.21.1</log4j.version>
    </properties>
    
    <dependencies>
        <!-- Selenium Java -->
        <dependency>
            <groupId>org.seleniumhq.selenium</groupId>
            <artifactId>selenium-java</artifactId>
            <version>`${selenium.version}</version>
        </dependency>
        
        <!-- WebDriverManager -->
        <dependency>
            <groupId>io.github.bonigarcia</groupId>
            <artifactId>webdrivermanager</artifactId>
            <version>`${webdrivermanager.version}</version>
        </dependency>
        
        <!-- TestNG -->
        <dependency>
            <groupId>org.testng</groupId>
            <artifactId>testng</artifactId>
            <version>`${testng.version}</version>
        </dependency>
        
        <!-- Log4j2 Core -->
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-core</artifactId>
            <version>`${log4j.version}</version>
        </dependency>
        
        <!-- Log4j2 API -->
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-api</artifactId>
            <version>`${log4j.version}</version>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <source>17</source>
                    <target>17</target>
                </configuration>
            </plugin>
            
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.2.2</version>
                <configuration>
                    <suiteXmlFiles>
                        <suiteXmlFile>src/test/resources/testng.xml</suiteXmlFile>
                    </suiteXmlFiles>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
"@ | Out-File -Encoding UTF8 pom.xml

Write-Host "✅ pom.xml created successfully" -ForegroundColor Green

# 6. Create project directories
Write-Host "📁 Creating project structure..." -ForegroundColor Cyan
$directories = @(
    "src\test\java\com\example\selenium\base",
    "src\test\java\com\example\selenium\pages", 
    "src\test\java\com\example\selenium\tests",
    "src\test\resources",
    "logs"
)

foreach ($dir in $directories) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

# 7. Create log4j2.xml configuration
@"
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="WARN">
    <Appenders>
        <Console name="Console" target="SYSTEM_OUT">
            <PatternLayout pattern="%d{HH:mm:ss.SSS} [%t] %highlight{%-5level} %logger{36} - %msg%n"/>
        </Console>
        
        <File name="FileAppender" fileName="logs/selenium-tests.log">
            <PatternLayout pattern="%d{yyyy-MM-dd HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n"/>
        </File>
    </Appenders>
    
    <Loggers>
        <Root level="INFO">
            <AppenderRef ref="Console"/>
            <AppenderRef ref="FileAppender"/>
        </Root>
    </Loggers>
</Configuration>
"@ | Out-File "src\test\resources\log4j2.xml" -Encoding UTF8

# 8. Create TestNG configuration
@"
<?xml version="1.0" encoding="UTF-8"?>
<suite name="SeleniumTestSuite">
    <test name="GoogleTests">
        <classes>
            <class name="com.example.selenium.tests.GoogleTest"/>
        </classes>
    </test>
</suite>
"@ | Out-File "src\test\resources\testng.xml" -Encoding UTF8

# 9. Create BaseTest class
@"
package com.example.selenium.base;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;

import java.time.Duration;

public class BaseTest {
    protected WebDriver driver;
    protected static final Logger logger = LogManager.getLogger(BaseTest.class);
    
    @BeforeMethod
    public void setUp() {
        logger.info("Setting up WebDriver...");
        
        // Setup ChromeDriver using WebDriverManager
        WebDriverManager.chromedriver().setup();
        
        // Chrome options for better stability
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--disable-blink-features=AutomationControlled");
        options.addArguments("--disable-extensions");
        options.addArguments("--no-sandbox");
        options.addArguments("--disable-dev-shm-usage");
        
        driver = new ChromeDriver(options);
        driver.manage().window().maximize();
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
        
        logger.info("WebDriver setup completed successfully");
    }
    
    @AfterMethod
    public void tearDown() {
        if (driver != null) {
            logger.info("Closing WebDriver...");
            driver.quit();
            logger.info("WebDriver closed successfully");
        }
    }
}
"@ | Out-File "src\test\java\com\example\selenium\base\BaseTest.java" -Encoding UTF8

# 10. Create GooglePage (Page Object pattern)
@"
package com.example.selenium.pages;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.time.Duration;

public class GooglePage {
    private WebDriver driver;
    private WebDriverWait wait;
    private static final Logger logger = LogManager.getLogger(GooglePage.class);
    
    @FindBy(name = "q")
    private WebElement searchBox;
    
    @FindBy(name = "btnK")
    private WebElement searchButton;
    
    public GooglePage(WebDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        PageFactory.initElements(driver, this);
        logger.info("GooglePage initialized");
    }
    
    public void openGoogle() {
        logger.info("Opening Google homepage");
        driver.get("https://www.google.com");
        wait.until(ExpectedConditions.visibilityOf(searchBox));
    }
    
    public void search(String searchTerm) {
        logger.info("Searching for: " + searchTerm);
        searchBox.clear();
        searchBox.sendKeys(searchTerm);
        
        // Wait for search button to be clickable and click
        wait.until(ExpectedConditions.elementToBeClickable(searchButton));
        searchButton.click();
    }
    
    public String getTitle() {
        String title = driver.getTitle();
        logger.info("Page title: " + title);
        return title;
    }
    
    public boolean isSearchResultsDisplayed() {
        try {
            WebElement results = wait.until(
                ExpectedConditions.presenceOfElementLocated(By.id("search"))
            );
            logger.info("Search results are displayed");
            return results.isDisplayed();
        } catch (Exception e) {
            logger.error("Search results not found: " + e.getMessage());
            return false;
        }
    }
}
"@ | Out-File "src\test\java\com\example\selenium\pages\GooglePage.java" -Encoding UTF8

# 11. Create GoogleTest
@"
package com.example.selenium.tests;

import com.example.selenium.base.BaseTest;
import com.example.selenium.pages.GooglePage;
import org.testng.Assert;
import org.testng.annotations.Test;

public class GoogleTest extends BaseTest {
    
    @Test(priority = 1)
    public void testGoogleHomePage() {
        logger.info("Starting testGoogleHomePage");
        
        GooglePage googlePage = new GooglePage(driver);
        googlePage.openGoogle();
        
        String title = googlePage.getTitle();
        Assert.assertTrue(title.contains("Google"), "Google homepage should contain 'Google' in title");
        
        logger.info("testGoogleHomePage completed successfully");
    }
    
    @Test(priority = 2)
    public void testGoogleSearch() {
        logger.info("Starting testGoogleSearch");
        
        GooglePage googlePage = new GooglePage(driver);
        googlePage.openGoogle();
        googlePage.search("Selenium WebDriver");
        
        boolean resultsDisplayed = googlePage.isSearchResultsDisplayed();
        Assert.assertTrue(resultsDisplayed, "Search results should be displayed");
        
        logger.info("testGoogleSearch completed successfully");
    }
}
"@ | Out-File "src\test\java\com\example\selenium\tests\GoogleTest.java" -Encoding UTF8

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

# 16. Install Maven dependencies and run tests
Write-Host "📥 Installing Maven dependencies..." -ForegroundColor Cyan
try {
    mvn clean compile test-compile
    Write-Host "✅ Maven dependencies installed successfully" -ForegroundColor Green
    
    Write-Host "🧪 Running initial tests..." -ForegroundColor Cyan
    mvn test
    Write-Host "✅ Initial tests completed successfully" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Maven dependency installation or tests had issues" -ForegroundColor Yellow
    Write-Host "You can manually run 'mvn clean compile test-compile' later" -ForegroundColor Yellow
}

Write-Host "`n🎉 Setup completed successfully!" -ForegroundColor Green
Write-Host "📁 Project created in: $(Get-Location)" -ForegroundColor Yellow
Write-Host "`n🚀 Quick commands to get started:" -ForegroundColor Magenta
Write-Host "   mvn test                 # Run all tests" -ForegroundColor White
Write-Host "   mvn test -Dtest=GoogleTest # Run specific test" -ForegroundColor White
Write-Host "   code .                   # Open in VS Code" -ForegroundColor White
Write-Host "`n💡 Check logs in logs/selenium-tests.log for detailed information" -ForegroundColor Cyan
