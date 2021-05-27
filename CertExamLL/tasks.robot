*** Settings ***
Documentation     Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.
Library        RPA.Browser
Library        RPA.PDF

*** Keywords ***
Open the robot order website
    No Operation

*** Keywords ***
Close the annoying modal
    No Operation

*** Keywords ***
Fill the form 
    No Operation

*** Keywords ***
Preview the robot
    No Operation

*** Keywords ***
Submit the order
    No Operation

*** Keywords ***
Agrega imagen de robot a PDF
    No Operation

*** Keywords ***
Go to order another robot
    No Operation

*** Keywords ***
Create a ZIP file of the receipts
    No Operation

*** Keywords ***
Store the receipt as a PDF file
    No Operation

*** Keywords ***
Take a screenshot of the robot
    No Operation

*** Keywords ***
Embed the robot screenshot to the receipt PDF file
    No Operation

*** Keywords ***
Get orders
    No Operation

*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Open the robot order website
    ${orders}=    Get orders
    FOR    ${row}    IN    @{orders}
        Close the annoying modal
        Fill the form    ${row}
        Preview the robot
        Submit the order
        ${pdf}=    Store the receipt as a PDF file    ${row}[Order number]
        ${screenshot}=    Take a screenshot of the robot    ${row}[Order number]
        Embed the robot screenshot to the receipt PDF file    ${screenshot}    ${pdf}
        Go to order another robot
    END
    Create a ZIP file of the receipts