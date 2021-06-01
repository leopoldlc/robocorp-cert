*** Settings ***
Documentation     Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.
...               Leopoldo Lara
Library        RPA.Browser.Selenium
Library        RPA.PDF
Library        RPA.HTTP
Library        RPA.Tables
Library        RPA.Archive

*** Keywords ***
Open the robot order website
    Open Available Browser        https://robotsparebinindustries.com/#/robot-order

*** Keywords ***
Download CSV file
    Download        https://robotsparebinindustries.com/orders.csv    overwrite=True

*** Keywords ***
Close the annoying modal
    Click Button    OK 

*** Keywords ***
Fill the form 
    [Arguments]    ${row}
    Select From List By Value    id:head    ${row}[Head]
    Click Element   xpath://input[@id='id-body-${row}[Body]']
    Input Text    css:input[placeholder="Enter the part number for the legs"]   ${row}[Legs]
    Input Text    id:address    ${row}[Address]

*** Keywords ***
Preview the robot
    Click Button    id:preview

*** Keywords ***
Submit the order
    Click Button    id:order
    Wait Until Element Is Visible    id:receipt

*** Keywords ***
Go to order another robot
    Click Button    id:order-another

*** Keywords ***
Create a ZIP file of the receipts
    Archive Folder With Zip    ${CURDIR}/data/order_receipts/pdf    ${OUTPUT_DIR}/orders.zip

*** Keywords ***
Store the receipt as a PDF file
    [Arguments]     ${ord_num}
    Wait Until Element Is Visible    id:receipt
    ${order_receipt}=   Get Element Attribute    id:receipt    outerHTML 
    ${order_pdf}=       Set Variable    ${CURDIR}/data/order_receipts/pdf/order_${ord_num}.pdf
    #Sleep   5 
    Html To Pdf    ${order_receipt}     ${order_pdf}
    [Return]    ${order_pdf}

*** Keywords ***
Take a screenshot of the robot
    [Arguments]     ${ord_num}
    Wait Until Element Is Visible    id:robot-preview-image
    Screenshot     id:robot-preview-image   ${CURDIR}/data/order_receipts/img/order_${ord_num}.png      
    [Return]            ${CURDIR}/data/order_receipts/img/order_${ord_num}.png

*** Keywords ***
Embed the robot screenshot to the receipt PDF file
    [Arguments]     ${screenshot}   ${pdf}
    Open Pdf    ${pdf}
    Add Watermark Image To Pdf    ${screenshot}     ${pdf}
    Close Pdf

*** Keywords ***
Get orders
    ${ord}=    Read Table From Csv    orders.csv
    #Set Row As Column Names    ${ord}    0
    [Return]    ${ord}

*** Keywords ***
Close robot order session
    Close Browser

*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Open the robot order website
    Download CSV file    
    ${orders}=    Get orders
    Log    Found columns: ${orders.columns}
    FOR    ${row}    IN    @{orders}
        Close the annoying modal
        Fill the form    ${row}
        Preview the robot
        # Runs the specified keyword and retries if it fails. "Wait Until Keyword Succeeds"
        Wait Until Keyword Succeeds     5 times   5s     Submit the order
        ${pdf}=    Store the receipt as a PDF file    ${row}[Order number]
        ${screenshot}=    Take a screenshot of the robot    ${row}[Order number]
        Log    ${pdf}, ${screenshot}
        Embed the robot screenshot to the receipt PDF file    ${screenshot}    ${pdf}
        Go to order another robot
    END
    Create a ZIP file of the receipts
    [TearDown]  Close robot order session




