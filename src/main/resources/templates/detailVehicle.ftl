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
    <style>
        .background_color {background: #f1f1f1;}
        table tbody td {padding-top: .2rem; padding-bottom: .2rem;}
        table thead th {font-weight: normal; padding-top: .2rem; padding-bottom: .2rem;}
        .td_value_1 {font-weight: bold;font-size: 1.1rem}
        .td_value_2 {font-size: 1.0rem}
        .table_bottom {margin-bottom: .5rem;}
        .accordion-title_app {font-size: 1.0rem; padding-top: .7rem; padding-bottom: .7rem}
        .accordion-content_app {padding: .7rem; padding-top: .3rem}
        .text-align-center {text-align: center}
    </style>

    <div class="grid-x">
        <div class="contaner cell">
            <div class="callout margin-top-05">
                <h4 class="text-center margin-bottom-0 title_decor padding-top-03">Сервисная книжка автомобиля</h4>
                <h5 class="text-center title_decor padding-bottom-05">Vehicle service book</h5>

                <div class="grid-x margin-top-1">
                    <div class="medium-4 large-3 cell" style="margin-left: 1rem">
                        <img src="../image/<#if objVehicle.photo??>${objVehicle.photo}<#else>${objVehicle.brand.photo}</#if>">
                    </div>
                    <div class="auto cell" style="padding-left: 2rem">
                        <table class="unstriped table_bottom">
                            <tr>
                                <td width="33%">Марка, модель ТС:</td>
                                <td class="td_value_1">${objVehicle.brand.name}</td>
                            </tr>
                            <tr>
                                <td width="33%">Общий пробег:</td>
                                <td id="mileage" class="td_value_1"></td>
                            </tr>
                            <tr>
                                <td width="33%">Прибор диагностики:</td>
                                <td class="td_value_2"><#if objVehicle.device??>${objVehicle.device.pid}</#if></td>
                            </tr>
                            <tr>
                                <td width="33%">Протокол связи:</td>
                                <td class="td_value_2">${objVehicle.protocol}</td>
                            </tr>
                            <tr>
                                <td width="33%">Баланс SIM карты:</td>
                                <td class="td_value_2"><#if objVehicle.device??>${objVehicle.device.balance} руб.</#if></td>
                            </tr>
                        </table>
                </div>
                </div>


                <ul class="accordion margin-top-1" data-accordion data-multi-expand="true">

                    <!-- Работы по замене расходных материалов -->
                    <li class="accordion-item is-active" data-accordion-item>
                        <a href="#" class="accordion-title accordion-title_app">Работы по замене расходных материалов</a>
                        <div class="accordion-content accordion-content_app" data-tab-content>
                            <table id="listConsumables" class="margin-bottom-05">
                                <thead class="title_decor">
                                    <tr>
                                        <th width="26%">Наименование</th>
                                        <th width="15%" class="text-align-center">Дата</th>
                                        <th width="12%" class="text-align-center">Ресурс</th>
                                        <th>Производитель, марка</th>
                                    </tr>
                                </thead>
                                <tbody id="dataConsumables">
                                </tbody>
                            </table>

                            <div style="overflow: hidden">
                                <div style="width: 100%;">
                                    <div class="small button-group margin-bottom-05" style="float:left">
                                        <a class="button disabled" data-open="popBrandDetails" onclick="buttonAddBrand()">Добавить</a>
                                        <a class="button disabled" id="buttonEditBrand" data-open="popBrandDetails" onclick="buttonEditBrand()">Изменить</a>
                                        <a class="button disabled" id="buttonDelBrand" data-open="popMessageBox">Удалить</a>
                                    </div>
                                    <ul id ="paginationConsumables" class="pagination text-right margin-bottom-0"  style="float:right" role="navigation" aria-label="Pagination">
                                    </ul>
                                </div>
                            </div>

                        </div>
                    </li>

                    <!-- Запасные части и прочие работы по обслуживанию -->
                    <li class="accordion-item" data-accordion-item>
                        <a href="#" class="accordion-title accordion-title_app">Запасные части и прочие работы по обслуживанию</a>
                        <div class="accordion-content accordion-content_app" data-tab-content>
                            <table id="listSpares" class="margin-bottom-05">
                                <thead class="title_decor">
                                <tr>
                                    <th width="26%">Наименование</th>
                                    <th width="15%" class="text-align-center">Дата</th>
                                    <th width="12%" class="text-align-center">Пройдено</th>
                                    <th>Производитель, марка</th>
                                </tr>
                                </thead>
                                <tbody id="dataSpares">
                                </tbody>
                            </table>

                            <div style="overflow: hidden">
                                <div style="width: 100%;">
                                    <div class="small button-group margin-bottom-05" style="float:left">
                                        <a class="button disabled" data-open="popBrandDetails" onclick="buttonAddBrand()">Добавить</a>
                                        <a class="button disabled" id="buttonEditBrand" data-open="popBrandDetails" onclick="buttonEditBrand()">Изменить</a>
                                        <a class="button disabled" id="buttonDelBrand" data-open="popMessageBox">Удалить</a>
                                    </div>
                                    <ul id ="paginationSpares" class="pagination text-right margin-bottom-0"  style="float:right" role="navigation" aria-label="Pagination">
                                    </ul>
                                </div>
                            </div>

                        </div>
                    </li>

                    <!-- Информационные сообщения -->
                    <li class="accordion-item" data-accordion-item>
                        <a href="#" class="accordion-title accordion-title_app">Информационные сообщения</a>
                        <div class="accordion-content accordion-content_app" data-tab-content>
                            <table id="listLogMessage" class="margin-bottom-05">
                                <thead class="title_decor">
                                <tr>
                                    <th width="14%">Тип</th>
                                    <th width="17%" class="text-align-center">Дата</th>
                                    <th>Сообщение</th>
                                </tr>
                                </thead>
                                <tbody id="dataLogMessage">
                                </tbody>
                            </table>
                            <ul id ="paginationLogMessage" class="pagination text-right" role="navigation" aria-label="Pagination" style="margin-bottom: 0">
                            </ul>
                        </div>
                    </li>
                </ul>
            </div>
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

            var formatter = new Intl.NumberFormat('ru', {minimumFractionDigits: 0, maximumFractionDigits: 0});
            var value = '${objVehicle.mileage}'.replace(/ /g,'',); // замена символа 0xA0
            $('#mileage').text((formatter.format(value / 1000)).replace(',','.')+' км.');

            $('#paginationConsumables').on('click', 'li', doConsumablesPaginationClick);
            $('#paginationSpares').on('click', 'li', doSparesPaginationClick);
            $('#paginationLogMessage').on('click', 'li', doLogMessagePaginationClick);
            doConsumablesPaginationClick();
            doSparesPaginationClick();
            doLogMessagePaginationClick();
        });
        //--------------------------------------------------------------------------------------------------------------
        function paintPaginationControl(active_page, count, size, object) {
            var frgmHtml = "";
            var countPage = parseInt(count / size);
            if(count % size != 0) countPage += 1;
            //frgmHtml += '<li class="pagination-previous disabled">Предыдущая</li>';
            for (var i = 1; i <= countPage; i++) {
                if(i == active_page)
                    frgmHtml += '<li class="current"><span class="show-for-sr"></span>'+i+'</li>';
                else
                    frgmHtml += '<li><a href="#">'+i+'</a></li>';
            }
            //frgmHtml += '<li class="pagination-next disabled">Следующая</li>';
            object.html(frgmHtml);
        }
        //--------------------------------------------------------------------------------------------------------------
        function doConsumablesPaginationControl(active_page) {
            paintPaginationControl(active_page, ${countConsumables}, ${sizeConsumables}, $('#paginationConsumables'));
        }
        //--------------------------------------------------------------------------------------------------------------
        function doSparesPaginationControl(active_page) {
            paintPaginationControl(active_page, ${countSpares}, ${sizeSpares}, $('#paginationSpares'));
        }
        //--------------------------------------------------------------------------------------------------------------
        function doLogMessagePaginationControl(active_page) {
            paintPaginationControl(active_page, ${countLogMessage}, ${sizeLogMessage}, $('#paginationLogMessage'));
        }
        //--------------------------------------------------------------------------------------------------------------
        function viewConsumables(data) {
            var frgmHtml = "";
            var obj = data;
            for (var i = 0; i < obj.length; ++i) {
                frgmHtml += '<tr>';
                frgmHtml += '<td>' + obj[i].name + '</td>';
                var ptr = obj[i].replaceDate;
                var dt =('0' + ptr.dayOfMonth).slice(-2) + '.' + ('0' + ptr.monthValue).slice(-2) + '.' + ptr.year;
                frgmHtml += '<td class="text-align-center">' + dt + '</td>';
                var remainder;
                if(obj[i].replaceMileage != null && obj[i].resourceMileage != null){
                    remainder = 100 - Math.round((('${objVehicle.mileage}'.replace(/ /g,'',) / 1000) - obj[i].replaceMileage) / obj[i].resourceMileage * 100);
                    remainder += ' %';
                } else {
                    remainder = '-';
                }
                frgmHtml += '<td class="text-align-center">' + remainder + '</td>';
                var text = '';
                if(obj[i].brand != null) text += obj[i].brand + '. ';
                if(obj[i].model != null) text += obj[i].model;
                frgmHtml += '<td>' + text + '</td>';
                frgmHtml += '</tr>';
            }
            $('#dataConsumables').html(frgmHtml);
        }
        //--------------------------------------------------------------------------------------------------------------
        function doConsumablesPaginationClick() {
            var page_num = parseInt($(this).text());
            if(isNaN(page_num)) page_num = 1;
            $.post('/consumables',
                {page_num: page_num, id: ${objVehicle.id}},
                function(data) {
                    viewConsumables(data);
                    doConsumablesPaginationControl(page_num);
                }
            );
        }
        //--------------------------------------------------------------------------------------------------------------
        function viewSpares(data) {
            var frgmHtml = "";
            var obj = data;
            for (var i = 0; i < obj.length; ++i) {
                frgmHtml += '<tr>';
                frgmHtml += '<td>' + obj[i].name + '</td>';
                var ptr = obj[i].replaceDate;
                var dt =('0' + ptr.dayOfMonth).slice(-2) + '.' + ('0' + ptr.monthValue).slice(-2) + '.' + ptr.year;
                frgmHtml += '<td class="text-align-center">' + dt + '</td>';
                var passed;
                if(obj[i].replaceMileage != null){
                    var formatter = new Intl.NumberFormat('ru', {
                        minimumFractionDigits: 0,
                        maximumFractionDigits: 0
                    });
                    passed = formatter.format(Math.round('${objVehicle.mileage}'.replace(/ /g,'',) / 1000) - obj[i].replaceMileage);
                    //passed += ' км.';
                } else {
                    passed = '-';
                }
                frgmHtml += '<td class="text-align-center">' + passed + '</td>';
                var text = '';
                if(obj[i].brand != null) text += obj[i].brand + '. ';
                if(obj[i].model != null) text += obj[i].model;
                frgmHtml += '<td>' + text + '</td>';
                frgmHtml += '</tr>';
            }
            $('#dataSpares').html(frgmHtml);
        }
        //--------------------------------------------------------------------------------------------------------------
        function doSparesPaginationClick() {
            var page_num = parseInt($(this).text());
            if(isNaN(page_num)) page_num = 1;
            $.post('/spares',
                {page_num: page_num, id: ${objVehicle.id}},
                function(data) {
                    viewSpares(data);
                    doSparesPaginationControl(page_num);
                }
            );
        }
        //--------------------------------------------------------------------------------------------------------------
        function viewLogMessage(data) {
            var frgmHtml = "";
            var obj = data;
            for (var i = 0; i < obj.length; ++i) {
                frgmHtml += '<tr>';
                frgmHtml += '<td>' + obj[i].type.name + '</td>';
                var ptr = obj[i].lastUpdate;
                var dt =    ('0' + ptr.dayOfMonth).slice(-2) + '.' +
                            ('0' + ptr.monthValue).slice(-2) + '.' + ptr.year + ' ' +
                            ('0' + ptr.hour).slice(-2) + ':' +
                            ('0' + ptr.minute).slice(-2);
                frgmHtml += '<td>' + dt + '</td>';
                frgmHtml += '<td>' + obj[i].message + '</td>';
                frgmHtml += '</tr>';
            }
            $('#dataLogMessage').html(frgmHtml);
        }
        //--------------------------------------------------------------------------------------------------------------
        function doLogMessagePaginationClick() {
            var page_num = parseInt($(this).text());
            if(isNaN(page_num)) page_num = 1;
            $.post('/logMessage',
                {page_num: page_num, id: ${objVehicle.id}},
                function(data) {
                    viewLogMessage(data);
                    doLogMessagePaginationControl(page_num);
                }
            );
        }
        //--------------------------------------------------------------------------------------------------------------
    </script>
</body>
</html>