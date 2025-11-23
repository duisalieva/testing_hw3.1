*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}         https://www.saucedemo.com/
${BROWSER}     chrome
${USERNAME}    standard_user
${PASSWORD}    secret_sauce

*** Test Cases ***

Login
    [Documentation]    Verify that user can log in with valid credentials
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Input Text    id=user-name    ${USERNAME}
    Input Text    id=password     ${PASSWORD}
    Click Button  id=login-button
    Wait Until Page Contains Element    class=inventory_list    10s
    Page Should Contain Element    class=inventory_item
    Close Browser


Products
    [Documentation]    Verify that all product elements are visible after login
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
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
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
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
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
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
        # ждём, пока кнопка появится в DOM
    Wait Until Page Contains Element    id=finish    10s

    # скроллим кнопку в видимую область (важно для Jenkins)
    Scroll Element Into View    id=finish

    # ждём, пока она станет кликабельной
    Wait Until Element Is Enabled    id=finish    10s

    Sleep    1s

    # пробуем клик (иногда 1-й fail — Jenkins так делает)
    Run Keyword And Ignore Error    Click Button    id=finish

    Sleep   1s

    # повторный клик — гарантирует стабильность
    Click Button    id=finish

    # теперь ждём заголовок
    Wait Until Element Contains    class=complete-header    THANK YOU FOR YOUR ORDER    10s

    Element Text Should Be    class=complete-header    THANK YOU FOR YOUR ORDER