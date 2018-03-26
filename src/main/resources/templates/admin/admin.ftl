<#import "/spring.ftl" as spring/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>


    <link type="text/css" rel="stylesheet" href="../css/foundation.min.css">
    <link type="text/css" rel="stylesheet" href="../css/app.css">

</head>
<body>

    <div class="grid-x">
        <div class="medium-8 medium-offset-2 large-6 large-offset-3 cell">
            <div class="callout primary margin-top-1">
                <h5 class="text-center">Панель администратора</h5>
            </div>
        </div>
    </div>

    <div class="grid-x">
        <div class="medium-8 medium-offset-2 large-6 large-offset-3 cell">
            <ul class="tabs" data-tabs id="tabsMain">
                <li class="tabs-title tabs-title-app is-active"><a class="tab-font" href="#panUser" aria-selected="true">Пользователи</a></li>
                <li class="tabs-title tabs-title-app"><a class="tab-font" href="#panBrand">Автомобили</a></li>
                <li class="tabs-title tabs-title-app"><a class="tab-font" href="#panConsumable">Расходные материалы</a></li>
            </ul>

            <div class="tabs-content" data-tabs-content="tabsMain">

                <!-- Список пользователей -->
                <div class="tabs-panel is-active" id="panUser">
                    <p>Список пользователей</p>
                </div>


                <!-- марки автомобилей -->
                <div class="tabs-panel" id="panBrand">
                    <table id="listBrand" class="unstriped">
                        <thead>
                        <tr>
                            <th class="display_none"></th>
                            <th width="150">Марка автомобиля</th>
                            <th width="50">Файл изображения</th>
                        </tr>
                        </thead>
                        <tbody id="dataBrand">
                             <#list objBrandList as Brand>
                             <tr>
                                 <td class="display_none">${Brand.id}</td>
                                 <td>${Brand.name}</td>
                                 <td>${Brand.photo}</td>
                             </tr>
                             </#list>
                        </tbody>
                    </table>
                    <div class="button-group">
                        <a class="button" data-open="popBrandDetails" onclick="buttonAddBrand()">Добавить</a>
                        <a class="button disabled" id="buttonEditBrand" data-open="popBrandDetails" onclick="buttonEditBrand()">Изменить</a>
                        <a class="button disabled" id="buttonDelBrand" data-open="popMessageBox">Удалить</a>
                    </div>

                    <div class="reveal" id="popBrandDetails" data-reveal>
                        <h5 id="titlePopBrandDetails"></h5>
                        <button class="close-button" data-close aria-label="Close reveal" type="button">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <form id="formBrandDetails" class="callout text-center">
                            <div class="floated-label-wrapper">
                                <input type="text" id="vehName" name="vehName" form="formBrandDetails" placeholder="Марка автомобиля">
                                <div class="input-group">
                                    <input class="input-group-field" type="text" id="vehPhoto" name="vehPhoto" form="formBrandDetails"
                                           placeholder="Изображение">
                                    <div class="input-group-button">
                                        <input type="button" class="button expanded" onclick="doGetPhotoFile()" value="...">
                                    </div>
                                </div>
                            </div>
                            <input class="button expanded" type="button" data-close onclick="doSendBrandDetails()" value="ОК">
                        </form>
                    </div>
                </div>


                <!-- -->
                <div class="tabs-panel" id="panConsumable">
                    <p>Список расходников</p>
                </div>

            </div>

            <div class="tiny reveal" id="popMessageBox" data-reveal>
                <h6>Вы действительно хотите удалить эту запись?</h6>
                <button class="close-button" data-close aria-label="Закрыть окно" type="button">
                    <span aria-hidden="true">&times;</span>
                </button>
                <div class="display-inline">
                    <input class="button button_app" type="button" data-close onclick="buttonDelBrand()" value="    ОК    ">
                    <input class="button button_app" data-close type="button" value="Отмена">
                </div">
            </div>

        </div>
    </div>


    <script type="text/javascript" src="../js/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="../js/jquery.json.min.js"></script>
    <script type="text/javascript" src="../js/foundation.min.js"></script>
    <script type="text/javascript" src="../js/what-input.js"></script>

    <script type="text/javascript">
        $(document).foundation();

        $(document).ready(function(){
            //setInterval('show()',1000); //пример таймера

            var clickTable = $('#listBrand');
            $('#listBrand tbody').on( "click", "tr",
                    {table: clickTable, buttonEdit: $('#buttonEditBrand'), buttonDel: $('#buttonDelBrand')}, doClickRow);
            cleaTableIndex(clickTable);

        });
        //--------- Выделение строк в таблице -------------------------------------------------------------------
        function cleaTableIndex(table) {
            $(table).attr('selectRow', 0);
            $(table).attr('selectId', 0);
        }
        //--------------------------------------------------------------------------------------------------------------
        function doClickRow(event) {
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
        function refreshTableBrand(data) {
            var fragmentHtml = "";
            //var obj = $.parseJSON(data);
            var obj = data;
            for (var i = 0; i < obj.length; ++i)
            {
                fragmentHtml += "<tr>";
                fragmentHtml += "<td class='display_none'\">" + obj[i].id + "</td>";
                fragmentHtml += "<td>" + obj[i].name + "</td>";
                fragmentHtml += "<td>" + obj[i].photo + "</td>";
                fragmentHtml += "</tr>";
            }
            $('#dataBrand').html(fragmentHtml);
            cleaTableIndex($('#listBrand'));
            $('#buttonEditBrand').addClass('disabled');
            $('#buttonDelBrand').addClass('disabled');
        }
        //--------------------------------------------------------------------------------------------------------------
        function buttonAddBrand() {
            $('#formBrandDetails').attr('submitType', 'add');
            $('#titlePopBrandDetails').text("Добавить марку автомобиля");
            $('#vehName').val('');
            $('#vehPhoto').val('');
        }
        //--------------------------------------------------------------------------------------------------------------
        function buttonEditBrand() {
            $('#formBrandDetails').attr('submitType', 'edit');
            $('#titlePopBrandDetails').text("Редактировать марку автомобиля");
            var id = $('#listBrand').attr('selectId');
            $.get('/${pathAdmin}/editBrand',
                {id: id},
                function(data) {
                    $('#vehName').val(data.name);
                    $('#vehPhoto').val(data.photo);
                }
            );
        }
        //--------------------------------------------------------------------------------------------------------------
        function buttonDelBrand() {
            var id = $('#listBrand').attr('selectId');
            $.post('/${pathAdmin}/delBrand',
                {id: id},
                function(data) {
                console.log(data);
                refreshTableBrand(data);
                }
            );
            /*$.ajax({
                url :           '/admin/delBrand',
                type:           'DELETE',
                contentType:    'application/json',
                data :          {"id": id},
                success: function (data) {
                    refreshTableBrand(data);
                }
            });*/
        }
        //--------------------------------------------------------------------------------------------------------------
        function doSendBrandDetails() {
            var url, msg, ajax_type;
            var type = $('#formBrandDetails').attr('submitType');
            if( type === 'add') {
                url = '/${pathAdmin}/addBrand';
                ajax_type = 'POST';
                msg = {id:null, name:$('#vehName').val(), photo:$('#vehPhoto').val()};
            }
            if(type === 'edit'){
                url = '/${pathAdmin}/editBrand';
                ajax_type = 'PUT';
                msg = {id:$('#listBrand').attr('selectId'), name:$('#vehName').val(), photo:$('#vehPhoto').val()};
            }
            $.ajax({
                url :           url,
                type:           ajax_type,
                contentType:    'application/json',
                data :          $.toJSON(msg),
                success: function (data) {
                    refreshTableBrand(data);
                }
            });
        }
        //--------------------------------------------------------------------------------------------------------------
        function doGetPhotoFile() {
            alert("File");
        }

    </script>

</body>
</html>