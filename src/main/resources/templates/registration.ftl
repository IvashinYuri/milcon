<#import "/spring.ftl" as spring/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Милкон</title>

    <link type="text/css" rel="stylesheet" href="../../css/foundation.min.css">
    <link type="text/css" rel="stylesheet" href="../../css/app.css">
</head>
<body class="background_color">
<div class="top-bar top-bar-app">
    <div class="top-bar-left">
        <ul class="menu">
            <li><a href="/login">Главная</a></li>
        </ul>
    </div>
</div>

<div class="grid-x">
    <div class="contaner cell margin-top-1">
        <h4 class="text-center margin-bottom-0 title_decor padding-top-03">Регистрация</h4>
        <h5 class="text-center title_decor padding-bottom-05 margin-bottom-0">создание новой учетной записи</h5>
        <div class="callout padding-top-2">
            <div class="grid-x">
                <div class="auto cell">
                <form onsubmit="return false" id="formPerson" class="form_person">
                    <div class="grid-x grid-padding-x">
                        <div class="small-4 cell">
                        </div>
                        <div class="small-8 cell">
                            <div id="message" style="margin-top: -1rem"></div>
                        </div>
                    </div>
                    <div class="grid-x grid-padding-x">
                        <div class="small-4 cell">
                            <label for="middle-label" class="text-right middle">Имя</label>
                        </div>
                        <div class="small-8 cell">
                            <input type="text" form="formPerson" id="first_name" placeholder="Введите имя">
                        </div>
                    </div>
                    <div class="grid-x grid-padding-x">
                        <div class="small-4 cell">
                            <label for="middle-label" class="text-right middle">Фамилия</label>
                        </div>
                        <div class="small-8 cell">
                            <input type="text" form="formPerson" id="last_name" placeholder="Введите фамилию">
                        </div>
                    </div>
                    <div class="grid-x grid-padding-x">
                        <div class="small-4 cell">
                            <label for="middle-label" class="text-right middle">Электронный адрес</label>
                        </div>
                        <div class="small-8 cell">
                            <input type="text" form="formPerson" id="email" placeholder="Введите Email">
                        </div>
                    </div>
                    <div class="grid-x grid-padding-x">
                        <div class="small-4 cell">
                            <label for="middle-label" class="text-right middle">Пароль</label>
                        </div>
                        <div class="small-8 cell">
                            <input type="password" form="formPerson" id="password" placeholder="Введите пароль">
                        </div>
                    </div>
                    <div class="grid-x grid-padding-x">
                        <div class="small-4 cell">
                            <label for="middle-label" class="text-right middle">Повторите пароль</label>
                        </div>
                        <div class="small-8 cell">
                            <input type="password" form="formPerson" id="password2" placeholder="Повторите пароль">
                        </div>
                    </div>
                    <div class="grid-x grid-padding-x">
                        <div class="small-4 cell">
                            <label for="middle-label" class="text-right middle">Часовой пояс</label>
                        </div>
                        <div class="small-8 cell">
                            <select id="timezone">
                                <option value="999"></option>
                                <option value="2">(UTC+2:00) Калининград</option>
                                <option value="3">(UTC+3:00) Москва, Санкт-Петербург</option>
                                <option value="4">(UTC+4:00) Ижевск, Самара</option>
                                <option value="5">(UTC+5:00) Екатеринбург</option>
                                <option value="6">(UTC+6:00) Новосибирск, Красноярск</option>
                                <option value="7">(UTC+7:00) Владивосток</option>
                                <option value="8">(UTC+8:00) Иркутск</option>
                                <option value="9">(UTC+9:00) Чита</option>
                                <option value="10">(UTC+10:00) Владивосток</option>
                                <option value="11">(UTC+11:00) Сахалин, Магадан</option>
                                <option value="12">(UTC+12:00) Петропавловск-Камчатский</option>
                            </select>
                        </div>
                    </div>
                    <div style="width: 100%; text-align: center; padding-left: 10rem">
                        <input class="button font-size-1 margin-bottom-05" type="submit" id="buttonReg" onclick="doRegistration()" value="Регистрация">
                    </div>
                </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript" src="../../js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="../../js/foundation.min.js"></script>
<script type="text/javascript" src="../../js/app.js"></script>
<script type="text/javascript">
    $(document).foundation();
    //------------------------------------------------------------------------------------------------------------------
    $(document).ready(function(){
    });
    //------------------------------------------------------------------------------------------------------------------
    function doRegistration() {
        if($('#buttonReg').attr('click_type') === '1') {
            $(location).attr('href','/login');
            return;
        }
        var message = $('#message');
        message.slideUp(0);
        var first_name = $('#first_name');
        var last_name = $('#last_name');
        var email = $('#email');
        var password = $('#password');
        var password2 = $('#password2');
        var timezone = $('#timezone');
        if(first_name.val() === ''){
            messageShow(message, 'Введите ваше имя.', null, 1);
            return;
        }
        if(email.val() === ''){
            messageShow(message, "Введите адрес вашей электронной почты.", null, 1);
            return;
        }
        var pattern=/^([a-z0-9_\.-])+@[a-z0-9-]+\.([a-z]{2,4}\.)?[a-z]{2,4}$/i;
        if(!pattern.test(email.val())){
            messageShow(message, "Неправильный формат адреса электронной почты.", null, 1);
            return;
        }
        if(password.val() === '' || password.val().length < 5){
            messageShow(message, "Задайте пароль (не менее 5 символов).", null, 1);
            return;
        }
        if(password.val() !== password2.val()){
            messageShow(message, "Введенные пароли не совпадают.", null, 1);
            return;
        }
        if(timezone.val() === "999"){
            messageShow(message, "Выберите ваш часовой пояс.", null, 1);
            return;
        }
        $.post('/signup', {
                first_name: first_name.val(),
                last_name: last_name.val(),
                email: email.val(),
                password: password.val(),
                timezone: timezone.val()
            },
            function(data) {
                if(data[0] === 'false') {
                    messageShow(message, data[1], data[2], 1);
                } else {
                    var obj = $('#buttonReg');
                    obj.val('Готово');
                    obj.attr('click_type', '1');
                    messageShow(message, data[1], data[2], 2);
                }
            }
        );
    }
    //------------------------------------------------------------------------------------------------------------------
</script>
</body>
</html>