# 6. Create project structure
Write-Host "📁 Creating project structure..." -ForegroundColor Cyan

# Create directories
$directories = @(
    "src\test\java\com\example\selenium\base",
    "src\test\java\com\example\selenium\pages",
    "src\test\java\com\example\selenium\tests",
    "src\test\resources"
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

Write-Host "✅ Project structure created successfully" -ForegroundColor Green
