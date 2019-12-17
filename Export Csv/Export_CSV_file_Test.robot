*** Settings ***
Library           SeleniumLibrary
Library           Collections   
Resource          Manager/DataManager.robot

*** Variables ***
${Url}        http://www.trirand.com/blog/phpjqgrid/examples/export/csv/default.php
${Browser}    Chrome
${row}         0
${path}        C:\\Users\\gajanan.bele\\Downloads\\exportdata.csv
${row_count}   0

*** Test Cases ***
Go To URL
    Go TO URL

Verify the Title 
    Verify the Title Must be "Simple CSV export"   

Export .csv file 
    Export .csv file using export option and save it

Verify total rows in .csv file should be equal to the total rows in table
     ${List_data} =   DataManager.Get csv Data    ${path}
    Verify Rows     ${List_data}
    Verify Table Data    ${List_data}
     
[Teardown]    Close Browser


*** Keywords ***
Go To URL
   Open Browser    ${Url}    ${Browser}
   Maximize Browser Window    

Verify the Title Must be "Simple CSV export" 
    Element Text Should Be   xpath=/html/body/div[1]/div/div[3]/div[1]/span     Simple CSV export
    
Export .csv file using export option and save it
    Click Element      xpath=/html/body/div[1]/div/div[5]/div/table/tbody/tr/td[1]/table/tbody/tr/td[3]/div/span
    sleep   10s

Verify Rows
    [Arguments]    ${List_data}
    ${list_count}=   Get Length  ${List_data}   
    ${list_count}=   Evaluate   ${list_count}-1
     :For  ${index}  IN RANGE  1   84
    \      ${row_found}=   Get Element Count   xpath=/html/body/div[1]/div/div[3]/div[3]/div/table/tbody/tr
    \      ${row_count}=   Evaluate   ${row_count}+${row_found}-1
    \      Click Element     xpath=//*[@id="next_pager"] 
    
    Should Be Equal   ${list_count}    ${row_count}

Verify Table Data
    [Arguments]    ${List_data}
    Reload Page
    sleep   5s
     :For  ${index}  IN RANGE  0   83
    \      Run Keyword      Table Rows Verification   ${List_data}    ${index}
    
Table Rows Verification
    [Arguments]    ${List_data}    ${index}
    ${index}    Evaluate    ${index}*10+1
    ${row_found}=   Get Element Count   xpath=/html/body/div[1]/div/div[3]/div[3]/div/table/tbody/tr

    :For  ${row}  IN RANGE  2  ${row_found}+1  
    \     ${data}   Get From List   ${List_data}   ${index}
    \     Table Row Should Contain   xpath=/html/body/div[1]/div/div[3]/div[3]/div/table   ${row}    ${data[0]}
    \     ${index}    Evaluate    ${index}+1
    
    Click Element     xpath=//*[@id="next_pager"]                   
    sleep  1s              


       