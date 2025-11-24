*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}             https://www.saucedemo.com/
${BROWSER}         chrome

${USERNAME}        standard_user
${PASSWORD}        secret_sauce

# ==== BrowserStack ====
${BS_USERNAME}     duisalievasabina_hwWtgm
${BS_ACCESS_KEY}   zn455DpzbeKBfaxqZ3ki
${REMOTE_URL}      https://${BS_USERNAME}:${BS_ACCESS_KEY}@hub-cloud.browserstack.com/wd/hub
${BS_OS}           OS X
${BS_OS_VERSION}   Sonoma
${BS_BUILD_NAME}   Saucedemo Robot HW

*** Test Cases ***

Login
    [Documentation]    Verify that user can log in with valid credentials
    Open SauceDemo In BrowserStack
    Input Text    id=user-name    ${USERNAME}
    Input Text    id=password     ${PASSWORD}
    Click Button  id=login-button
    Wait Until Page Contains Element    class=inventory_list    10s
    Page Should Contain Element    class=inventory_item
    Close Browser


Products
    [Documentation]    Verify that all product elements are visible after login
    Open SauceDemo In BrowserStack
    Input Text    id=user-name    ${USERNAME}
    Input Text    id=password     ${PASSWORD}
    Click Button  id=login-button
    Wait Until Page Contains Element    class=inventory_list    10s
    Page Should Contain Element         class=inventory_item
    ${items}=    Get WebElements    class=inventory_item_name
    Log Many    ${items}
    Should Not Be Empty    ${items}
    Close Browser


Adding to card
    [Documentation]    Verify that user can add a product to the shopping cart
    Open SauceDemo In BrowserStack
    Input Text    id=user-name    ${USERNAME}
    Input Text    id=password     ${PASSWORD}
    Click Button  id=login-button
    Wait Until Page Contains Element    class=inventory_list    10s
    Click Button    xpath=//button[@id='add-to-cart-sauce-labs-backpack']
    Click Element   class=shopping_cart_link
    Wait Until Page Contains Element    class=cart_item    10s
    Page Should Contain Element         class=inventory_item_name
    Close Browser


Completing
    [Documentation]    Verify that user can complete checkout successfully
    Open SauceDemo In BrowserStack
    Input Text    id=user-name    ${USERNAME}
    Input Text    id=password     ${PASSWORD}
    Click Button  id=login-button
    Wait Until Page Contains Element    class=inventory_list    10s
    Click Button    xpath=//button[@id='add-to-cart-sauce-labs-bike-light']
    Click Element   class=shopping_cart_link
    Wait Until Page Contains Element    class=cart_item    10s
    Click Button    id=checkout
    Wait Until Page Contains Element    id=first-name    10s
    Input Text    id=first-name    Galateya
    Input Text    id=last-name     Test
    Input Text    id=postal-code   090003
    Click Button   id=continue


    Wait Until Element Is Visible    id=finish    10s
    Scroll Element Into View         id=finish
    Sleep    1s


    Execute Javascript    document.getElementById("finish").click();


    Sleep    2s


    Wait Until Page Contains    Thank you for your order!    15s
    Page Should Contain         Thank you for your order!

    Close Browser

*** Keywords ***
Open SauceDemo In BrowserStack
    [Arguments]    ${browser}=${BROWSER}
    ${caps}=    Create Dictionary
    ...    browserName=${browser}
    ...    os=${BS_OS}
    ...    osVersion=${BS_OS_VERSION}
    ...    buildName=${BS_BUILD_NAME}
    ...    sessionName=Saucedemo_${browser}

    Open Browser    ${URL}    ${browser}    remote_url=${REMOTE_URL}    desired_capabilities=${caps}
    Maximize Browser Window