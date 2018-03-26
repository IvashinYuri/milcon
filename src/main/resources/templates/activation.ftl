<#import "/spring.ftl" as spring/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Милкон</title>

    <link type="text/css" rel="stylesheet" href="../css/foundation.min.css">
    <link type="text/css" rel="stylesheet" href="../css/app.css">
</head>
<body>
<script type="text/javascript" src="../js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="../js/foundation.min.js"></script>
<div class="grid-x">
    <div class="medium-6 medium-offset-3 large-4 large-offset-4 cell">
        <div class="callout margin-top-2 <#if message[0] == 'true'>success"<#else>alert</#if> ">
            <h5>${message[1]}</h5>
            <h6>${message[2]}</h6>
            <div style="width: 100%; text-align: center">
                <#if message[0] == 'true'><a class="button success hollow font-size-1 margin-top-2 margin-bottom-0" href="/login">Главная</a><#else></#if>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).foundation();

    $(document).ready(function(){
    });
</script>
</body>
</html>