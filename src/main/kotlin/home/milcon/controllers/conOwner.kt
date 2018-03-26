package home.milcon.controllers

import com.google.gson.GsonBuilder
import home.milcon.models.*
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.*
import home.milcon.repositories.*
import home.milcon.services.BCrypt
import home.milcon.services.CustomException
import java.net.URL
import java.time.LocalDate
import java.time.LocalDateTime
import javax.servlet.http.HttpServletRequest

@Controller
@RequestMapping("/owner")
class OwnerController {
    @Autowired lateinit var repBrand:       BrandRepository
    @Autowired lateinit var repDevice:      DeviceRepository
    @Autowired lateinit var repVehicle:     VehicleRepository
    @Autowired lateinit var repOwner:       OwnerRepository
    @Autowired lateinit var repLog:         LogRepository
    @Autowired lateinit var repConsumables: ConsumablesRepository
    @Autowired lateinit var repSpares :     SparesRepository

    val page_size = 10

    //------------------------------------------------------------------------------------------------------------------
    @GetMapping("/person")
    fun doRerson(model: Model, request: HttpServletRequest): String {
        val session = request.getSession(true)
        val check = session.getAttribute("owner")
        if(check != null) {
            model.addAttribute("person", check as Owner)
            return "owner/person"
        } else {
            return "redirect:/login"
        }
    }
    //------------------------------------------------------------------------------------------------------------------
    @PostMapping("/person_save")
    @ResponseBody
    fun doPersonSave(id: Int, first_name: String, last_name: String, email: String, password: String, timezone: String,
                 model: Model, request: HttpServletRequest): MutableList<String> {

        var message: MutableList<String>
        val session = request.getSession(true)
        val owner_old = session.getAttribute("owner") as Owner
        try {
            if(email != owner_old.email) {
                val owner = repOwner.findOneByEmail(email)
                if (owner != null) {
                    message = mutableListOf("false")
                    message.add("Ошибка!")
                    message.add("Электронный адрес уже зарегистрирован.")
                    return message
                }
            }
            var hash_password = owner_old.password
            if(password.length > 0) {
                hash_password = BCrypt.hash(password, 5)
            }
            val owner = Owner(id, first_name, last_name, email, hash_password, timezone.toInt(), owner_old.active, owner_old.status)
            repOwner.save(owner)
            session.setAttribute("owner", owner)
            message = mutableListOf("true")
            message.add("Данные успешно сохранены!")
            message.add(" ")
            return message
        } catch(e: Exception){
            message = mutableListOf("false")
            message.add("Ошибка!")
            message.add("Программное исключение времени выполнения.")
            return message
        }
    }
    //------------------------------------------------------------------------------------------------------------------
    @GetMapping("/vehicles")
    fun doVehicles(model: Model, request: HttpServletRequest): String {
        val session = request.getSession(true)
        val check = session.getAttribute("owner")
        if(check != null) {
            val owner = check as Owner
            val vehicles = repVehicle.findByOwnerIdAndDeletedIsNullOrderById(owner.id!!)
            model.addAttribute("person", owner)
            model.addAttribute("vehicles", vehicles)
            return "owner/vehicles"
        } else {
            return "redirect:/login"
        }
    }
    //------------------------------------------------------------------------------------------------------------------
    @GetMapping("/logout")
    fun doLogout(model: Model, request: HttpServletRequest): String {
        val session = request.getSession(true)
        session.removeAttribute("owner")
        return "redirect:/login"
    }
    //------------------------------------------------------------------------------------------------------------------
    @GetMapping("/service_book/{id}")
    fun doServiceBook(@PathVariable(name = "id") id: Int, model: Model, request: HttpServletRequest): String {

        val session = request.getSession(true)
        if(session.getAttribute("owner") == null) return "redirect:/login"

        model.addAttribute("person", session.getAttribute("owner") as Owner)
        model.addAttribute("idVehicle", id)
        val objVehicle = repVehicle.findOne(id)
        objVehicle.protocol = getProtocolNameFromCode(objVehicle.protocol)
        model.addAttribute("objVehicle", objVehicle)

        val count_consum = repConsumables.countByVehicleId(objVehicle.id!!)
        model.addAttribute("countConsumables", count_consum)
        model.addAttribute("sizeConsumables", page_size)

        val count_spares = repSpares.countByVehicleId(objVehicle.id)
        model.addAttribute("countSpares", count_spares)
        model.addAttribute("sizeSpares", page_size)

        val count_log = repLog.countByVehicleId(objVehicle.id)
        model.addAttribute("countLogMessage", count_log)
        model.addAttribute("sizeLogMessage", page_size)

        return "owner/service_book"
    }
    //-----------------------------------------------------------------------------------------------------------------
    @PostMapping("/vehicle_id")
    @ResponseBody
    fun doVehicleId(id: Int, request: HttpServletRequest): Vehicle {
        val session = request.getSession(true)
        if (session.getAttribute("owner") != null) {
            return repVehicle.findOne(id)
        }
        return repVehicle.findOne(0)
    }
    //-----------------------------------------------------------------------------------------------------------------
    @PostMapping("/vehicle_save")
    @ResponseBody
    fun doVehicleSave(id: Int?, name: String, model: String, edition: String, photo: String,
                      pid: String, mileage: Int, request: HttpServletRequest): List<String> {

        var message: MutableList<String>
        try {
            val session = request.getSession(true)
            if (session.getAttribute("owner") != null) {
                val device: Device?
                if (pid.isNotEmpty()) {
                    device = repDevice.findOneByPid(pid)
                    if (device == null) {
                        message = mutableListOf("false")
                        message.add("Номер не зарегистрирован!")
                        message.add("Если у вас нет прибора или вы не знаете его серийного номера, оставьте поле пустым.")
                        return message
                    }
                } else  {device = null}
                val owner = session.getAttribute("owner") as Owner
                val brand = repBrand.findByNameAndModelAndEdition(name, model, edition)
                val vehicle = Vehicle(  id = id, ownerId = owner.id, brand = brand, device = device,
                        mileage = mileage * 1000, photo = if(photo.isEmpty()) null else photo)
                repVehicle.save(vehicle)
                message = mutableListOf("true")
                message.add("/owner/vehicles")
                return message
            } else {
                //throw CustomException("User is not authorized")
                message = mutableListOf("true")
                message.add("/login")
                return message
            }
        }  catch(e: Exception) {
            message = mutableListOf("false")
            message.add("Ошибка!")
            message.add("Программное исключение времени выполнения.")
            return message
        }
    }
    //-----------------------------------------------------------------------------------------------------------------
    @PostMapping("/vehicle_del")
    @ResponseBody
    fun doVehicleDelete(id: Int, request: HttpServletRequest): String {

        val session = request.getSession(true)
        if(session.getAttribute("owner") != null) {
            val vehicle = repVehicle.findOne(id)
            vehicle.deleted = LocalDateTime.now()
            repVehicle.save(vehicle)
        }
        return "/owner/vehicles"
    }
    //-----------------------------------------------------------------------------------------------------------------
    @PostMapping("/brand_name")
    @ResponseBody
    fun getBrandNames(): List<String> {

        return repBrand.findNames()
    }
    //-----------------------------------------------------------------------------------------------------------------
    @PostMapping("/brand_model")
    @ResponseBody
    fun getBrandModels(name: String): List<String> {

        return repBrand.findModels(name)
    }
    //-----------------------------------------------------------------------------------------------------------------
    @PostMapping("/brand_edition")
    @ResponseBody
    fun getBrandEditions(name: String, model: String): List<String> {

        return repBrand.findEditions(name, model)
    }
    //------------------------------------------------------------------------------------------------------------------
    @PostMapping("/consumables_id")
    @ResponseBody
    fun doConsumablesId(id: Int, request: HttpServletRequest): Consumables {
        val session = request.getSession(true)
        if (session.getAttribute("owner") != null) {
            return repConsumables.findOne(id)
        }
        return repConsumables.findOne(0)
    }
    //------------------------------------------------------------------------------------------------------------------
    @PostMapping("/consumables_save")
    @ResponseBody
    fun doConsumablesSave(id: Int?, vehicle_id: Int, name: String, replaceDate: String, replaceMileage: Int,
                          brand: String, model: String, resourceDate: String, resourceMileage: String,
                          type: String, request: HttpServletRequest): List<String> {
        var message: MutableList<String>
        try {
            val session = request.getSession(true)
            if (session.getAttribute("owner") != null) {
                val consum = Consumables(id, vehicle_id, name, LocalDate.parse(replaceDate), replaceMileage, brand, model,
                        if(resourceDate.isEmpty()) null else resourceDate.toInt(),
                        if(resourceMileage.isEmpty()) null else resourceMileage.toInt())
                repConsumables.save(consum)
                var type_id = 0
                if(type == "add") type_id = 5 else type_id = 7
                repLog.save(LogMessage(vehicleId = vehicle_id, type = LogType(id = type_id),
                        //lastUpdate = LocalDateTime.parse(replaceDate),
                        message = name+" "+replaceDate+" "+replaceMileage+" "+brand+" "+model+" "+resourceDate+" "+resourceMileage))
                message = mutableListOf("true")
                message.add("/owner/service_book/" + vehicle_id.toString())
                return message
            } else {
                message = mutableListOf("true")
                message.add("/login")
                return message
            }
        }  catch(e: Exception) {
            message = mutableListOf("false")
            message.add("Ошибка!")
            message.add("Программное исключение времени выполнения.")
            return message
        }
    }
    //------------------------------------------------------------------------------------------------------------------
    @PostMapping("/consumables_del")
    @ResponseBody
    fun doConsumablesDelete(id: Int, vehicle_id: Int, request: HttpServletRequest): String {
        val session = request.getSession(true)
        if(session.getAttribute("owner") != null) {
            val consum = repConsumables.findOne(id)
            repConsumables.delete(id)
            repLog.save(LogMessage(vehicleId = vehicle_id, type = LogType(id = 8),
                    message =   consum.name+" "+consum.replaceDate+" "+consum.replaceMileage+" "+consum.brand+" "+
                                consum.model+" "+consum.resourceDate+" "+consum.resourceMileage))
        }
        return "/owner/service_book/" + vehicle_id.toString()
    }
    //------------------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------------------
    @PostMapping("/spares_id")
    @ResponseBody
    fun doSparesId(id: Int, request: HttpServletRequest): Spares {
        val session = request.getSession(true)
        if (session.getAttribute("owner") != null) {
            return repSpares.findOne(id)
        }
        return repSpares.findOne(0)
    }
    //------------------------------------------------------------------------------------------------------------------
    @PostMapping("/spares_save")
    @ResponseBody
    fun doSparesSave(id: Int?, vehicle_id: Int, name: String, replaceDate: String, replaceMileage: Int,
                          brand: String, model: String, type: String, request: HttpServletRequest): List<String> {
        var message: MutableList<String>
        try {
            val session = request.getSession(true)
            if (session.getAttribute("owner") != null) {
                val spares = Spares(id, vehicle_id, name, LocalDate.parse(replaceDate), replaceMileage, brand, model)
                repSpares.save(spares)
                var type_id = 0
                if(type == "add") type_id = 4 else type_id = 7
                repLog.save(LogMessage(vehicleId = vehicle_id, type = LogType(id = type_id),
                        //lastUpdate = LocalDateTime.parse(replaceDate),
                        message = name+" "+replaceDate+" "+replaceMileage+" "+brand+" "+model))
                message = mutableListOf("true")
                message.add("/owner/service_book/" + vehicle_id.toString())
                return message
            } else {
                message = mutableListOf("true")
                message.add("/login")
                return message
            }
        }  catch(e: Exception) {
            message = mutableListOf("false")
            message.add("Ошибка!")
            message.add("Программное исключение времени выполнения.")
            return message
        }
    }
    //------------------------------------------------------------------------------------------------------------------
    @PostMapping("/spares_del")
    @ResponseBody
    fun doSparesDelete(id: Int, vehicle_id: Int, request: HttpServletRequest): String {
        val session = request.getSession(true)
        if(session.getAttribute("owner") != null) {
            val spares = repSpares.findOne(id)
            repSpares.delete(id)
            repLog.save(LogMessage(vehicleId = vehicle_id, type = LogType(id = 8),
                    message = spares.name+" "+spares.replaceDate+" "+spares.replaceMileage+" "+spares.brand+" "+spares.model))
        }
        return "/owner/service_book/" + vehicle_id.toString()
    }
}