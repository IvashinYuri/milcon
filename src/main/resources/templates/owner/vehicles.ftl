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
            <li><a href="/owner/person">Профиль</a></li>
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
    <div class="contaner cell margin-top-1" id="box">
        <h4 class="text-center margin-bottom-0 title_decor padding-top-03">Автопарк</h4>
        <h5 class="text-center title_decor padding-bottom-05 margin-bottom-0">список автомобилей пользователя</h5>
        <div class="callout padding-top-2">
            <div class="grid-x small-up-2 medium-up-3 large-up-4 margin-top-2">
                <#list vehicles as vehicle>
                    <div class="cell margin-right-2">
                        <a href="/owner/service_book/${vehicle.id}">
                            <div class="card">
                                <div class="card-divider padding-top-05 padding-bottom-05">
                                    <h5>${vehicle.brand.name} ${vehicle.brand.model}</h5>
                                    <label>
                                        <input type="checkbox" id="check_${vehicle.id}" vehicle="${vehicle.id}"/>
                                    </label>
                                </div>
                                <img src="../../image/<#if vehicle.photo??>${vehicle.photo}<#else>${vehicle.brand.photo}</#if>">
                                <div class="card-section padding-top-05 padding-bottom-05">
                                    <h5 id="mileage_${vehicle.id}" class="margin-bottom-0"></h5>
                                    <script type="text/javascript">
                                        var formatter = new Intl.NumberFormat('ru', {
                                            minimumFractionDigits: 0,
                                            maximumFractionDigits: 0
                                        });
                                        var value = '${vehicle.mileage}'.replace(/ /g,'',); // замена символа 0xA0
                                        var obj = document.getElementById('mileage_${vehicle.id}');
                                        obj.innerHTML = 'Пробег: '+(formatter.format(value / 1000)).replace(',','.')+' км.';
                                    </script>
                                </div>
                            </div>
                        </a>
                    </div>
                </#list>
            </div>
            <hr>
            <div style="overflow: hidden">
                <div style="width: 100%;">
                    <div class="button-group margin-bottom-05" style="float:left;letter-spacing: .01rem">
                        <button type="button" class="button primary" data-open="popVehicleDetails" onclick="clickVehicleAdd()">Добавить</button>
                        <button type="button" class="button primary" disabled id="btnEditVehicle" data-open="popVehicleDetails" onclick="clickVehicleEdit()">Редактировать</button>
                        <button type="button" class="button primary" disabled id="btnDelVehicle" data-open="popVehicleDelete">Удалить</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="reveal" id="popVehicleDetails" data-reveal>
    <h5 id="titleVehicleDetails"></h5>
    <hr class="margin-top-05 margin-bottom-1">
    <div class="grid-x grid-padding-x">
        <div class="auto cell">
            <div id="message"></div>
        </div>
        <form onsubmit="return false" id="formVehicleDetails" style="width: 100%; padding-right: 1rem">
            <div class="grid-x grid-padding-x">
                <div class="small-4 cell">
                    <label for="middle-label" class="text-right middle">Производитель</label>
                </div>
                <div class="small-8 cell">
                    <select class="select_disabled" id="selVehicleBrand" disabled onchange="changeVehicleBrand()">
                    </select>
                </div>
            </div>
            <div class="grid-x grid-padding-x">
                <div class="small-4 cell">
                    <label for="middle-label" class="text-right middle">Модель, марка</label>
                </div>
                <div class="small-8 cell">
                    <select class="select_disabled" id="selVehicleModel" disabled onchange="changeVehicleModel()">
                    </select>
                </div>
            </div>
            <div class="grid-x grid-padding-x">
                <div class="small-4 cell">
                    <label for="middle-label" class="text-right middle">Поколение</label>
                </div>
                <div class="small-8 cell">
                    <select class="select_disabled" id="selVehicleEdition" disabled onchange="changeVehicleEdition()">
                        <option disabled selected></option>
                    </select>
                </div>
            </div>
            <div class="grid-x grid-padding-x">
                <div class="small-4 cell">
                    <label for="middle-label" class="text-right middle">Номер прибора</label>
                </div>
                <div class="small-8 cell">
                    <input type="number" id="inpVehiclePid"</input>
                </div>
            </div>
            <div class="grid-x grid-padding-x">
                <div class="small-4 cell">
                    <label for="middle-label" class="text-right middle">Пробег (км)</label>
                </div>
                <div class="small-8 cell">
                    <input type="number" id="inpVehicleMileage" value="0">
                </div>
            </div>
        </form>
    </div>
    <div class="button-group margin-top-1 margin-bottom-0" style="margin-left: 30%;">
        <button type="button" class="button primary margin-right-1" id="btnVehicleSave" onclick="clickVehicleSave()">Сохранить</button>
        <button type="button" class="button primary" data-close>Отмена</button>
    </div>
    <button class="close-button" data-close aria-label="Закрыть око" type="button">
        <span aria-hidden="true">&times;</span>
    </button>
</div>


<div class="reveal" id="popVehicleDelete" data-reveal>
    <h5>Удаление автомобиля</h5>
    <hr class="margin-top-05 margin-bottom-05">
    <div class="grid-x grid-padding-x" style="color:black">
        <p>Вся информация об автомобиле, в том числе о расходных материалах и запасных частях, будет утеряна.</p>
        <h6>Вы действительно хотите удалить этот автомобиль?</h6>
    </div>
    <div class="button-group margin-top-1 margin-bottom-0" style="margin-left: 30%;">
        <button type="button" class="button primary margin-right-1" onclick="clickVehicleDelete()">Удалить</button>
        <button type="button" class="button primary" data-close>Отмена</button>
    </div>
    <button class="close-button" data-close aria-label="Закрыть око" type="button">
        <span aria-hidden="true">&times;</span>
    </button>
</div>
<script type="text/javascript" src="../../js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="../../js/foundation.min.js"></script>
<script type="text/javascript" src="../../js/app.js"></script>
<script type="text/javascript">
    $(document).foundation();
    //------------------------------------------------------------------------------------------------------------------
    $(document).ready(function(){
        $(':checkbox').on('change', doCheckChange);
        $('#box').attr('selectId', 0);
    });
    //------------------------------------------------------------------------------------------------------------------
    function clickVehicleAdd() {
        $('#formVehicleDetails').attr('submitType', 'add');
        $('#titleVehicleDetails').text("Добавление автомобиля");
        clearSelect($('#selVehicleBrand'));
        clearSelect($('#selVehicleModel'));
        clearSelect($('#selVehicleEdition'));
        $('#inpVehiclePid').val('');
        $('#inpVehicleMileage').val(0);
        $('#message').html('');
        $('#btnVehicleSave').prop('disabled', true);
        getBrandName();
    }
    //------------------------------------------------------------------------------------------------------------------
    function clickVehicleEdit() {
        $('#formVehicleDetails').attr('submitType', 'edit');
        $('#titleVehicleDetails').text("Редактирование автомобиля");
        var brand = $('#selVehicleBrand');
        var model = $('#selVehicleModel');
        var edition = $('#selVehicleEdition');
        clearSelect(brand);
        clearSelect(model);
        clearSelect(edition);
        $('#inpVehiclePid').val('');
        $('#inpVehicleMileage').val('');
        $('#message').html('');
        $('#btnVehicleSave').prop('disabled', false);
        var id = $('#box').attr('selectId');
        $.post('/owner/vehicle_id',
            {id: id},
            function (data) {
                if(data.device != null) $('#inpVehiclePid').val(data.device.pid);
                $('#inpVehicleMileage').val(Math.floor(data.mileage / 1000));

                fillBrandName(brand).done(function(c){
                    brand.find('option[value="'+data.brand.name+'"]').prop('selected', true);
                    refontSelect(brand);
                });
                fillBrandModel(model, data.brand.name).done(function(c){
                    model.find('option[value="'+data.brand.model+'"]').prop('selected', true);
                    refontSelect(model);
                });
                fillBrandEdition(edition, data.brand.name, data.brand.model).done(function(c){
                    edition.find('option[value="'+data.brand.edition+'"]').prop('selected', true);
                    refontSelect(edition);
                });
            }
        );
    }
    //------------------------------------------------------------------------------------------------------------------
    function getBrandName() {
        var brand = $('#selVehicleBrand');
        brand.empty();
        fillBrandName(brand);
    }
    //------------------------------------------------------------------------------------------------------------------
    function fillBrandName(brand) {
        return $.post('/owner/brand_name',
            function (data) {
                brand.append( $('<option value="" disabled selected hidden>Выберите производителя</option>'));
                $.each(data,function(index,obj)
                {
                    brand.append( $('<option class="select_enabled" value="'+obj+'">'+obj+'</option>'));
                });
                brand.prop('disabled', false);
            }
        );
    }
    //------------------------------------------------------------------------------------------------------------------
    function changeVehicleBrand() {
        var brand = $('#selVehicleBrand');
        var model = $('#selVehicleModel');
        var edition = $('#selVehicleEdition');
        var brand_val = brand.val();
        clearSelect(model);
        clearSelect(edition);
        fillBrandModel(model, brand_val).done(function(c){
            refontSelect(brand);
            $('#btnVehicleSave').prop('disabled', true);
        });
    }
    //------------------------------------------------------------------------------------------------------------------
    function fillBrandModel(model, brand_val) {
        return $.post('/owner/brand_model',
            {name: brand_val},
            function (data) {
                model.append( $('<option value="" disabled selected hidden>Выберите модель</option>'));
                $.each(data,function(index,obj)
                {
                    model.append( $('<option class="select_enabled" value="'+obj+'">'+obj+'</option>'));
                });
                model.prop('disabled', false);
            }
        );
    }
    //------------------------------------------------------------------------------------------------------------------
    function changeVehicleModel() {
        var model = $('#selVehicleModel');
        var edition = $('#selVehicleEdition');
        var brand_val = $('#selVehicleBrand').val();
        var model_val = model.val();
        clearSelect(edition);
        fillBrandEdition(edition, brand_val, model_val).done(function(c){
            refontSelect(model);
            $('#btnVehicleSave').prop('disabled', true);
        });
    }
    //------------------------------------------------------------------------------------------------------------------
    function fillBrandEdition(edition, brand_val, model_val) {
        return $.post('/owner/brand_edition',
            {name: brand_val, model: model_val},
            function (data) {
                edition.append( $('<option value="" disabled selected hidden>Выберите поколение</option>'));
                $.each(data,function(index,obj)
                {
                    edition.append( $('<option class="select_enabled" value="'+obj+'">'+obj+'</option>'));
                });
                edition.prop('disabled', false);
            }
        );
    }
    //------------------------------------------------------------------------------------------------------------------
    function changeVehicleEdition() {
        refontSelect($('#selVehicleEdition'));
        $('#btnVehicleSave').prop('disabled', false);
    }
    //------------------------------------------------------------------------------------------------------------------
    function clearSelect(obj) {
        obj.empty();
        obj.prop('disabled', true);
        obj.removeClass('select_enabled');
        obj.addClass('select_disabled');
    }
    //------------------------------------------------------------------------------------------------------------------
    function refontSelect(obj) {
        obj.removeClass('select_disabled');
        obj.addClass('select_enabled');
    }
    //------------------------------------------------------------------------------------------------------------------
    function clickVehicleSave() {
        var brand_val = $('#selVehicleBrand :selected').val();
        var model_val = $('#selVehicleModel :selected').val();
        var edition_val = $('#selVehicleEdition :selected').val();
        var photo = null;
        var id;
        if($('#formVehicleDetails').attr('submitType') === 'add') id = null; else id = $('#box').attr('selectId');
        $.post('/owner/vehicle_save', {
                id: id,
                name: brand_val,
                model: model_val,
                edition: edition_val,
                photo: photo,
                pid: $('#inpVehiclePid').val(),
                mileage: $('#inpVehicleMileage').val()
            },
            function (data) {
                if(data[0] === 'false') {
                    messageShow($('#message'), data[1], data[2], 1);
                } else {
                    $(location).attr('href', data[1]);
                }
            }
        );
    }
    //------------------------------------------------------------------------------------------------------------------
    function clickVehicleDelete() {
        var id = $('#box').attr('selectId');
        $.post('/owner/vehicle_del',
            {id: id},
            function (data) {
                $(location).attr('href', data);
            }
        );
    }
    //------------------------------------------------------------------------------------------------------------------
    function doCheckChange() {
        var id = $('#box').attr('selectId');
        if($(this).prop('checked')) {
            if(id > 0) {
                $('#check_'+id).prop('checked',false);
            }
            $('#box').attr('selectId', $(this).attr('vehicle'));
            $('#btnEditVehicle').prop('disabled', false);
            $('#btnDelVehicle').prop('disabled', false);
        } else {
            $('#box').attr('selectId', 0);
            $('#btnEditVehicle').prop('disabled', true);
            $('#btnDelVehicle').prop('disabled', true);
        }
    }
    //------------------------------------------------------------------------------------------------------------------
</script>
</body>
</html>