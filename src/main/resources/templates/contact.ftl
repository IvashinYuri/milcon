<#import "/spring.ftl" as spring/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Милкон</title>
    <link type="text/css" rel="stylesheet" href="./css/foundation.min.css">
    <link type="text/css" rel="stylesheet" href="./css/app.css">
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
        <h5 class="text-center margin-bottom-0 title_decor padding-top-05 padding-bottom-05" >Контактная информация</h5>
        <div class="callout padding-top-2">
            <div class="grid-x">
                <div class="auto cell">
                    <div class="grid-x grid-padding-x">
                        <div class="small-6 cell">
                            <label for="middle-label" class="text-right middle" style="font-size: 1.2rem">Электронная почта:</label>
                        </div>
                        <div class="small-6 cell">
                            <label for="middle-label" class="text-left middle" style="font-size: 1.2rem">info@ledmon.ru</label>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript" src="../js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="../js/foundation.min.js"></script>
<script type="text/javascript">
    $(document).foundation();
    $(document).ready(function(){
    });
</script>
</body>
</html>