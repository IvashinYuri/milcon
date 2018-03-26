<#import "/spring.ftl" as spring/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Милкон</title>

    <link type="text/css" rel="stylesheet" href="./css/foundation.min.css">
    <link type="text/css" rel="stylesheet" href="./css/app.css">
</head>
<body>
<script type="text/javascript" src="../js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="../js/foundation.min.js"></script>


<div class="grid-x">
    <div class="contaner cell">
        <div class="callout margin-top-05" style="padding: 0">
            <h4 class="text-center title_decor" style="padding: .5rem">Список автомобилей</h4>
        </div>
    </div>
</div>
<div class="grid-x">
    <div class="contaner cell">
        <div class="grid-x small-up-2 medium-up-3 large-up-4">
            <#list vehicles as vehicle>
                <div class="cell" style="margin-right: 1rem">
                    <a href="/detailVehicle/${vehicle.id}">
                        <div class="card">
                            <div class="card-divider padding-top-05 padding-bottom-05">
                                <h5>${vehicle.brand.name}</h5>
                            </div>
                            <img src="./image/<#if vehicle.photo??>${vehicle.photo}<#else>${vehicle.brand.photo}</#if>">
                            <div class="card-section padding-top-05 padding-bottom-05">
                                <h5 id="mileage_${vehicle.id}" class="margin-bottom-0"></h5>
                                <script type="text/javascript">
                                    var formatter = new Intl.NumberFormat('ru', {
                                        minimumFractionDigits: 0,
                                        maximumFractionDigits: 0
                                    });
                                    var value = '${vehicle.mileage}'.replace(/ /g,'',); // замена символа 0xA0
                                    $('#mileage_${vehicle.id}').text('Пробег: '+(formatter.format(value / 1000)).replace(',','.')+' км.');
                                </script>
                            </div>
                        </div>
                    </a>
                </div>
            </#list>
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