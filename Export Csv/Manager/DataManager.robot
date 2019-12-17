*** Settings ***
Library           ../CustomLibrary/Csv.py


*** Keywords ***
Get csv Data
    [Arguments]     ${filepath}
    ${Data} =       read csv file     ${filepath}
    [Return]       ${Data}