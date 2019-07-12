*** Settings ***
Library  SeleniumLibrary
Library  String

*** Variables ***
${JOOMLA_SITE}  http://www.ciediweb.it/automation_contest/
${JOOMLA_REG}   http://www.ciediweb.it/automation_contest/index.php/component/users/?view=registration&Itemid=101
${JOOMLA_SUB_ARTICLE}   http://www.ciediweb.it/automation_contest/index.php/submit-an-article
${YAHOO_SITE}   https://it.yahoo.com

${USERNAME}     Generated during setup
${PASSWORD}     password

*** Test Cases ***

Test Contest
    [Setup]     Setup Test

    ${title}    ${article}      Get First Article From Yahoo

    Register User
    Login User
    Submit An Article           ${title}    ${article}

    [Teardown]  Close Browser


*** Keywords ***

Setup Test
    Generate User
    open browser    ${YAHOO_SITE}  Chrome

Register User
    go to       ${JOOMLA_REG}
    input text  jform_name  nome
    input text  jform_username      ${USERNAME}
    input text  jform_password1     ${PASSWORD}
    input text  jform_password2     ${PASSWORD}
    input text  jform_email1        ${USERNAME}@yopmail.com
    input text  jform_email2        ${USERNAME}@yopmail.com
    click button    Registrati

Login User
    input text      username    ${USERNAME}
    input text      password    ${PASSWORD}
    click button    Accedi

Submit An Article
    [Arguments]     ${title}=default title    ${article}=default text
    go to  ${JOOMLA_SUB_ARTICLE}
    input text      jform_title    Luca Emanuele Daniele - ${title}
    # Click Editor sì/No button to disable wyswyg html editor
    click element   //*[@id="editor"]/div[3]/div[2]/div/a
    input text      jform_articletext   ${article}
    # Change tab to change category
    click link      \#publishing
    # Click the select for changing category
    click element   jform_catid_chzn
    # Click the option blog post
    click element   //*[@data-option-array-index="1"]
    # Click Salva save button
    click button    //*[@id="adminForm"]/div/div[1]/button

Generate User
    ${random}=          generate random string  8
    log to console      ${random}
    set test variable   ${USERNAME}  ${random}

Get First Article From Yahoo
    go to   ${YAHOO_SITE}
    # Close cookie policy disclaimer
    click button    agree
    # Click the link to read the first article
    click element   //*/span[contains(text(), 'Leggi l')]
    ${title}=       get text        modal-header
    ${article}=     get text        //*[@class='body-wrapper']
    # Debug information to see whether contet has been read
    log to console  ${title}
    log to console  ${article}
    [Return]  ${title}    ${article}
