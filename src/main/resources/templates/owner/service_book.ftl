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

    <div class="top-bar top-bar-app">
        <div class="top-bar-left">
            <ul class="menu">
                <li><a href="/owner/person/">Профиль</a></li>
                <li><a href="/owner/vehicles/">Автопарк</a></li>

            </ul>
        </div>
        <div class="top-bar-right">
            <ul class="menu">
                <h6 class="top_menu_title">${person.last_name} ${person.first_name}</h6>
                <h6 class="top_menu_title margin-left-1 margin-right-1">( ${person.email} )</h6>
                <li><a href="/owner/logout">Выход</a></li>
            </ul>

        </div>
    </div>

    <div class="grid-x">
        <div class="contaner cell margin-top-1">
            <h4 class="text-center margin-bottom-0 title_decor padding-top-03">Сервисная книжка автомобиля</h4>
            <h5 class="text-center title_decor padding-bottom-05 margin-bottom-0">vehicle service book</h5>
            <div class="callout padding-top-2">
                <div class="grid-x">
                    <div class="medium-4 large-3 cell" style="margin-left: 1rem">
                        <img src="../../image/<#if objVehicle.photo??>${objVehicle.photo}<#else>${objVehicle.brand.photo}</#if>">
                    </div>
                    <div class="auto cell" style="padding-left: 2rem">
                        <table class="unstriped table_bottom">
                            <tr>
                                <td width="33%">Марка, модель ТС:</td>
                                <td class="td_value_1">${objVehicle.brand.name} ${objVehicle.brand.model}</td>
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
                                        <a class="button" data-open="popConsumablesDetails" onclick="clickConsumablesAdd()">Добавить</a>
                                        <a class="button disabled" id="btnConsumablesEdit" data-open="popConsumablesDetails" onclick="clickConsumablesEdit()">Изменить</a>
                                        <a class="button disabled" id="btnConsumablesDel" data-open="popConsumablesDelete"">Удалить</a>
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
                                        <a class="button" data-open="popSparesDetails" onclick="clickSparesAdd()">Добавить</a>
                                        <a class="button disabled" id="btnSparesEdit" data-open="popSparesDetails" onclick="clickSparesEdit()">Изменить</a>
                                        <a class="button disabled" id="btnSparesDel" data-open="popSparesDelete">Удалить</a>
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

    <div class="reveal" id="popConsumablesDetails" data-reveal>
        <h5 id="titleConsumablesDetails"></h5>
        <hr class="margin-top-05 margin-bottom-1">
        <div class="grid-x grid-padding-x">
            <div class="auto cell">
                <div id="message"></div>
            </div>
            <form onsubmit="return false" id="formConsumablesDetails" style="width: 100%; padding-right: 1rem">
                <div class="grid-x grid-padding-x">
                    <div class="small-4 cell">
                        <label for="middle-label" class="text-right middle">Наименование</label>
                    </div>
                    <div class="small-8 cell">
                        <input type="text" id="consumName" list="consumNameList"</input>
                        <datalist id="consumNameList">
                        </datalist>
                    </div>
                    <div class="small-4 cell">
                        <label for="middle-label" class="text-right middle">Дата замены</label>
                    </div>
                    <div class="small-8 cell">
                        <input type="date" id="consumReplaceDate"</input>
                    </div>
                    <div class="small-4 cell">
                        <label for="middle-label" class="text-right middle">Одометр (км)</label>
                    </div>
                    <div class="small-8 cell">
                        <input type="number" id="consumReplaceMileage"</input>
                    </div>
                    <div class="small-4 cell">
                        <label for="middle-label" class="text-right middle">Производитель</label>
                    </div>
                    <div class="small-8 cell">
                        <input type="text" id="consumBrand"</input>
                    </div>
                    <div class="small-4 cell">
                        <label for="middle-label" class="text-right middle">Модель, марка</label>
                    </div>
                    <div class="small-8 cell">
                        <input type="text" id="consumModel"</input>
                    </div>
                    <div class="small-4 cell">
                        <label for="middle-label" class="text-right middle">Ресурс (мес)</label>
                    </div>
                    <div class="small-8 cell">
                        <input type="number" id="consumResourceDate"</input>
                    </div>
                    <div class="small-4 cell">
                        <label for="middle-label" class="text-right middle">Ресурс (км)</label>
                    </div>
                    <div class="small-8 cell">
                        <input type="number" id="consumResourceMileage"</input>
                    </div>
                </div>
            </form>
            <div class="button-group margin-top-1 margin-bottom-0" style="margin-left: 30%;">
                <button type="button" class="button primary margin-right-1" id="btnConsumablesSave" onclick="clickConsumablesSave()">Сохранить</button>
                <button type="button" class="button primary" data-close>Отмена</button>
            </div>
            <button class="close-button" data-close aria-label="Закрыть око" type="button">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
    </div>
    <div class="reveal" id="popConsumablesDelete" data-reveal>
        <h5>Удаление расходного материала</h5>
        <hr class="margin-top-05 margin-bottom-05">
        <div class="grid-x grid-padding-x" style="color:black">
            <p>Вся информация о расходном материале и его ресурсе будет утеряна.</p>
            <h6>Вы действительно хотите удалить эту запись?</h6>
        </div>
        <div class="button-group margin-top-1 margin-bottom-0" style="margin-left: 30%;">
            <button type="button" class="button primary margin-right-1"  onclick="clickConsumablesDel()">Удалить</button>
            <button type="button" class="button primary" data-close>Отмена</button>
        </div>
        <button class="close-button" data-close aria-label="Закрыть око" type="button">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <div class="reveal" id="popSparesDetails" data-reveal>
    <h5 id="titleSparesDetails"></h5>
    <hr class="margin-top-05 margin-bottom-1">
    <div class="grid-x grid-padding-x">
        <div class="auto cell">
            <div id="message2"></div>
        </div>
        <form onsubmit="return false" id="formSparesDetails" style="width: 100%; padding-right: 1rem">
            <div class="grid-x grid-padding-x">
                <div class="small-4 cell">
                    <label for="middle-label" class="text-right middle">Наименование</label>
                </div>
                <div class="small-8 cell">
                    <input type="text" id="sparesName" list="sparesNameList"</input>
                    <datalist id="sparesNameList">
                    </datalist>
                </div>
                <div class="small-4 cell">
                    <label for="middle-label" class="text-right middle">Дата замены</label>
                </div>
                <div class="small-8 cell">
                    <input type="date" id="sparesReplaceDate"</input>
                </div>
                <div class="small-4 cell">
                    <label for="middle-label" class="text-right middle">Одометр (км)</label>
                </div>
                <div class="small-8 cell">
                    <input type="number" id="sparesReplaceMileage"</input>
                </div>
                <div class="small-4 cell">
                    <label for="middle-label" class="text-right middle">Производитель</label>
                </div>
                <div class="small-8 cell">
                    <input type="text" id="sparesBrand"</input>
                </div>
                <div class="small-4 cell">
                    <label for="middle-label" class="text-right middle">Модель, марка</label>
                </div>
                <div class="small-8 cell">
                    <input type="text" id="sparesModel"</input>
                </div>
            </div>
        </form>
        <div class="button-group margin-top-1 margin-bottom-0" style="margin-left: 30%;">
            <button type="button" class="button primary margin-right-1" id="btnSparesSave" onclick="clickSparesSave()">Сохранить</button>
            <button type="button" class="button primary" data-close>Отмена</button>
        </div>
        <button class="close-button" data-close aria-label="Закрыть око" type="button">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
    </div>
    <div class="reveal" id="popSparesDelete" data-reveal>
        <h5>Удаление запасной части</h5>
        <hr class="margin-top-05 margin-bottom-05">
        <div class="grid-x grid-padding-x" style="color:black">
            <p>Вся информация о запасной части будет утеряна.</p>
            <h6>Вы действительно хотите удалить эту запись?</h6>
        </div>
        <div class="button-group margin-top-1 margin-bottom-0" style="margin-left: 30%;">
            <button type="button" class="button primary margin-right-1"  onclick="clickSparesDel()">Удалить</button>
            <button type="button" class="button primary" data-close>Отмена</button>
        </div>
        <button class="close-button" data-close aria-label="Закрыть око" type="button">
            <span aria-hidden="true">&times;</span>
        </button>
    </div>
    <script type="text/javascript" src="../../js/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="../../js/jquery.json.min.js"></script>
    <script type="text/javascript" src="../../js/foundation.min.js"></script>
    <script type="text/javascript" src="../../js/what-input.js"></script>
    <script type="text/javascript" src="../../js/app.js"></script>

    <script type="text/javascript">
        $(document).foundation();
        //--------------------------------------------------------------------------------------------------------------
        $(document).ready(function(){
            var formatter = new Intl.NumberFormat('ru', {minimumFractionDigits: 0, maximumFractionDigits: 0});
            var value = '${objVehicle.mileage}'.replace(/ /g,'',); // замена символа 0xA0
            $('#mileage').text((formatter.format(value / 1000)).replace(',','.')+' км.');
            var table;
            table = $('#listConsumables');
            table.on( "click", "tbody tr",
                    {table: table, buttonEdit: $('#btnConsumablesEdit'), buttonDel: $('#btnConsumablesDel')}, clickTableRow);
            cleaTableIndex(table);
            table = $('#listSpares');
            table.on( "click", "tbody tr",
                    {table: table, buttonEdit: $('#btnSparesEdit'), buttonDel: $('#btnSparesDel')}, clickTableRow);
            cleaTableIndex(table);
            $('#paginationConsumables').on('click', 'li', doConsumablesPaginationClick);
            $('#paginationSpares').on('click', 'li', doSparesPaginationClick);
            $('#paginationLogMessage').on('click', 'li', doLogMessagePaginationClick);
            doConsumablesPaginationClick();
            doSparesPaginationClick();
            doLogMessagePaginationClick();
        });
        //--------------------------------------------------------------------------------------------------------------
        function clickTableRow(event) {
            event.stopPropagation();
            if($(this).hasClass('select_row')){
                $(this).removeClass('select_row');
                cleaTableIndex(event.data.table);
                event.data.buttonEdit.addClass('disabled');
                event.data.buttonDel.addClass('disabled');
                return;
            }
            var index = event.data.table.attr('selectRow');
            if(index > 0) {
                event.data.table.find('tr:eq(' + index + ')').removeClass('select_row');
            }
            $(this).addClass('select_row');
            event.data.table.attr('selectRow', $(this).index() + 1);
            event.data.table.attr('selectId', $(this).find('td:eq(0)').text());
            event.data.buttonEdit.removeClass('disabled');
            event.data.buttonDel.removeClass('disabled');
        }
        //--------------------------------------------------------------------------------------------------------------
        function cleaTableIndex(table) {
            $(table).attr('selectRow', 0);
            $(table).attr('selectId', 0);
        }
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
        //==============================================================================================================
        function clickConsumablesAdd() {
            $('#formConsumablesDetails').attr('submitType', 'add');
            $('#titleConsumablesDetails').text("Добавление информации о расходном материале");
            $('#consumName').val('');
            $('#consumReplaceDate').attr('value', convertDateNowToString());
            $('#consumReplaceMileage').val(Math.round('${objVehicle.mileage}'.replace(/ /g,'',) / 1000));
            $('#consumBrand').val('');
            $('#consumModel').val('');
            $('#consumResourceDate').val('');
            $('#consumResourceMileage').val('');
            messageHide($('#message'));
        }
        //--------------------------------------------------------------------------------------------------------------
        function clickConsumablesEdit() {
            $('#formConsumablesDetails').attr('submitType', 'edit');
            $('#titleConsumablesDetails').text("Редактирование информации о расходном материале");
            var id = $('#listConsumables').attr('selectId');
            $.post('/owner/consumables_id',
                {id: id},
                function (data) {
                    $('#consumName').val(data.name);
                    var ptr = data.replaceDate;
                    var date = ptr.year + '-' + ('0' + ptr.monthValue).slice(-2) + '-' + ('0' + ptr.dayOfMonth).slice(-2);
                    $('#consumReplaceDate').attr('value', date);
                    $('#consumReplaceMileage').val(data.replaceMileage);
                    $('#consumBrand').val(data.brand);
                    $('#consumModel').val(data.model);
                    $('#consumResourceDate').val(data.resourceDate);
                    $('#consumResourceMileage').val(data.resourceMileage);
                }
            );
            messageHide($('#message'));
        }
        //--------------------------------------------------------------------------------------------------------------
        function clickConsumablesDel() {
            var id = $('#listConsumables').attr('selectId');
            $.post('/owner/consumables_del',
                {id: id, vehicle_id: '${objVehicle.id}'},
                function (data) {
                    $(location).attr('href', data);
                }
            );
        }
        //--------------------------------------------------------------------------------------------------------------
        function clickConsumablesSave() {
            var message = $('#message');
            messageHide(message);
            var name = $('#consumName').val();
            if(name.trim() === '') {
                messageShow(message, 'Необходимо ввести наименование расходника.', null, 1);
                return;
            }
            var replaceDate = $('#consumReplaceDate').val();
            if(replaceDate.trim() === '') {
                messageShow(message, 'Необходимо ввести дату замены расходника.', null, 1);
                return;
            }
            var replaceMileage = $('#consumReplaceMileage').val();
            if(replaceMileage.trim() === '') {
                messageShow(message, 'Необходимо ввести пробег автомобиля.', null, 1);
                return;
            }
            var brand = $('#consumBrand').val();
            var model = $('#consumModel').val();
            var resourceDate = $('#consumResourceDate').val();
            var resourceMileage = $('#consumResourceMileage').val();
            if(resourceDate === '' && resourceMileage === '') {
                messageShow(message, 'Необходимо ввести ресурс расходника по дате или по пробегу.', null, 1);
                return;
            }
            var id;
            if($('#formConsumablesDetails').attr('submitType') === 'add') id = null; else id = $('#listConsumables').attr('selectId');
            $.post('/owner/consumables_save', {
                    id: id,
                    vehicle_id: '${objVehicle.id}',
                    name: name,
                    replaceDate: replaceDate,
                    replaceMileage: replaceMileage,
                    brand: brand,
                    model: model,
                    resourceDate: resourceDate,
                    resourceMileage: resourceMileage,
                    type: $('#formConsumablesDetails').attr('submitType')
                },
                function (data) {
                    if(data[0] === 'false') {
                        messageShow(message, data[1], data[2], 1);
                    } else {
                        $(location).attr('href', data[1]);
                    }
                }
            );
        }
        //--------------------------------------------------------------------------------------------------------------

        //--------------------------------------------------------------------------------------------------------------
        function viewConsumables(data) {
            var frgmHtml = "";
            var obj = data;
            for (var i = 0; i < obj.length; ++i) {
                frgmHtml += '<tr>';
                frgmHtml += '<td class="display_none"\">' + obj[i].id + '</td>';
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
        function doConsumablesPaginationControl(active_page) {
            paintPaginationControl(active_page, ${countConsumables}, ${sizeConsumables}, $('#paginationConsumables'));
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

        //==============================================================================================================
        function doSparesPaginationControl(active_page) {
            paintPaginationControl(active_page, ${countSpares}, ${sizeSpares}, $('#paginationSpares'));
        }
        //--------------------------------------------------------------------------------------------------------------
        function clickSparesAdd() {
            $('#formSparesDetails').attr('submitType', 'add');
            $('#titleSparesDetails').text("Добавление информацию о запчасти");
            $('#sparesName').val('');
            $('#sparesReplaceDate').attr('value', convertDateNowToString());
            $('#sparesReplaceMileage').val(Math.round('${objVehicle.mileage}'.replace(/ /g,'',) / 1000));
            $('#sparesBrand').val('');
            $('#sparesModel').val('');
            messageHide($('#message2'));
        }
        //--------------------------------------------------------------------------------------------------------------
        function clickSparesEdit() {
            $('#formSparesDetails').attr('submitType', 'edit');
            $('#titleSparesDetails').text("Редактирование информации о запчасти");
            var id = $('#listSpares').attr('selectId');
            console.log(id);
            $.post('/owner/spares_id',
                    {id: id},
                    function (data) {
                        $('#sparesName').val(data.name);
                        var ptr = data.replaceDate;
                        var date = ptr.year + '-' + ('0' + ptr.monthValue).slice(-2) + '-' + ('0' + ptr.dayOfMonth).slice(-2);
                        $('#sparesReplaceDate').attr('value', date);
                        $('#sparesReplaceMileage').val(data.replaceMileage);
                        $('#sparesBrand').val(data.brand);
                        $('#sparesModel').val(data.model);
                    }
            );
            messageHide($('#message2'));
        }
        //--------------------------------------------------------------------------------------------------------------
        function clickSparesDel() {
            var id = $('#listSpares').attr('selectId');
            $.post('/owner/spares_del',
                    {id: id, vehicle_id: '${objVehicle.id}'},
                    function (data) {
                        $(location).attr('href', data);
                    }
            );
        }
        //--------------------------------------------------------------------------------------------------------------
        function clickSparesSave() {
            var message = $('#message2');
            messageHide(message);
            var name = $('#sparesName').val();
            if(name.trim() === '') {
                messageShow(message, 'Необходимо ввести наименование запчасти.', null, 1);
                return;
            }
            var replaceDate = $('#sparesReplaceDate').val();
            if(replaceDate.trim() === '') {
                messageShow(message, 'Необходимо ввести дату замены запчасти.', null, 1);
                return;
            }
            var replaceMileage = $('#sparesReplaceMileage').val();
            if(replaceMileage.trim() === '') {
                messageShow(message, 'Необходимо ввести пробег автомобиля.', null, 1);
                return;
            }
            var brand = $('#sparesBrand').val();
            var model = $('#sparesModel').val();
            var id;
            if($('#formSparesDetails').attr('submitType') === 'add') id = null; else id = $('#listSpares').attr('selectId');
            console.log(id);
            $.post('/owner/spares_save', {
                    id: id,
                    vehicle_id: '${objVehicle.id}',
                    name: name,
                    replaceDate: replaceDate,
                    replaceMileage: replaceMileage,
                    brand: brand,
                    model: model,
                    type: $('#formSparesDetails').attr('submitType')
                },
                function (data) {
                    if(data[0] === 'false') {
                        messageShow(message, data[1], data[2], 1);
                    } else {
                        $(location).attr('href', data[1]);
                    }
                }
            );
        }
        //--------------------------------------------------------------------------------------------------------------
        function viewSpares(data) {
            var frgmHtml = "";
            var obj = data;
            for (var i = 0; i < obj.length; ++i) {
                frgmHtml += '<tr>';
                frgmHtml += '<td class="display_none"\">' + obj[i].id + '</td>';
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
        //==============================================================================================================
        function doLogMessagePaginationControl(active_page) {
            paintPaginationControl(active_page, ${countLogMessage}, ${sizeLogMessage}, $('#paginationLogMessage'));
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