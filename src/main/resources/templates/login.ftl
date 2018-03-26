<#import "/spring.ftl" as spring/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Милкон</title>

    <link type="text/css" rel="stylesheet" href="../css/foundation.min.css">
    <link type="text/css" rel="stylesheet" href="../css/app.css">


</head>
<body class="background_color">
    <div class="top-bar top-bar-app">
        <div class="top-bar-left">
            <ul class="menu">

            </ul>
        </div>
        <div class="top-bar-right">
            <ul class="menu">
                <li><a href="/contact">Контакт</a></li>
            </ul>
        </div>
    </div>

    <div class="grid-x">
        <div class="contaner cell margin-top-1">
            <h4 class="text-center margin-bottom-0 title_decor padding-top-03">МИЛКОН</h4>
            <h5 class="text-center title_decor padding-bottom-05 margin-bottom-0">Mileage of consumables</h5>
            <div class="callout padding-top-2">
                <div class="grid-x">
                    <div class="auto cell margin-left-1">
                        <h6></h6>
                    </div>
                    <div class="medium-5 large-4 cell padding-left-2">
                        <div class="callout primary margin-top-05" style="overflow: hidden">
                            <h5>Вход в личный кабинет</h5>
                            <h6 id="error" style="color: red; display: none"></h6>
                            <form onsubmit="return false">
                                <input type="text" placeholder="Адрес электронной почты" id="login">
                                <input type="password" placeholder="Пароль" id="password">
                                <button type="submit" class="button font-size-1 margin-bottom-0" onclick="sendData()">Войти</button>
                                <a class="clear button font-size-1 margin-bottom-0" style="float: right" href="/registration">Регистрация</a>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <#include "message.ftl">
        </div>
    </div>

    <script type="text/javascript" src="../js/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="../js/jquery.json.min.js"></script>
    <script type="text/javascript" src="../js/foundation.min.js"></script>
    <script type="text/javascript" src="../js/what-input.js"></script>
    <script type="text/javascript">
        $(document).foundation();
        //--------------------------------------------------------------------------------------------------------------
        $(document).ready(function(){

        });
        //--------------------------------------------------------------------------------------------------------------
        function sendData() {
            $.post('/signin',
                {login: $('#login').val(), password: $('#password').val()},
                function(data) {
                    if(data[0] === 'false') {
                        $('#error').html(data[1]);
                        $('#error').slideDown();
                        setTimeout (function(){
                            $('#error').slideUp();
                        }, 1500);
                    } else {
                        $(location).attr('href',data[1]);
                    }
                }
            );
        }
        //--------------------------------------------------------------------------------------------------------------
    </script>
</body>
</html>