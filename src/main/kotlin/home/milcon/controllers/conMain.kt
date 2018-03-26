package home.milcon.controllers

import com.google.gson.GsonBuilder
import home.milcon.MilconApplication
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.*
import home.milcon.models.*
import home.milcon.repositories.*
import home.milcon.services.*
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Pageable
import org.springframework.data.domain.Sort
import java.io.File
import java.time.format.DateTimeFormatter
import java.security.CodeSource
import com.sun.org.apache.xerces.internal.util.DOMUtil.getParent
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.mail.MailException
import org.springframework.mail.SimpleMailMessage
import java.net.MalformedURLException
import java.io.UnsupportedEncodingException
import java.net.URL
import java.nio.file.Path
import java.nio.file.Paths
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession
import org.springframework.web.servlet.view.RedirectView
import java.time.LocalDateTime
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.mail.javamail.JavaMailSenderImpl
import org.springframework.mail.javamail.MimeMessageHelper
import org.springframework.stereotype.Component
import org.springframework.stereotype.Service
import org.springframework.web.bind.annotation.*

@Controller
class MainController {
    @Autowired lateinit var repVehicle  : VehicleRepository
    @Autowired lateinit var repOwner  : OwnerRepository
    @Autowired lateinit var repLog  : LogRepository
    @Autowired lateinit var repConsumables  : ConsumablesRepository
    @Autowired lateinit var repSpares  : SparesRepository

    val page_size = 10
    //-----------------------------------------------------------------------------------------------------------------
    @GetMapping("/login")
    fun login(model: Model): String {
        return "login"
    }
    //-----------------------------------------------------------------------------------------------------------------
    @GetMapping("/registration")
    fun registration(model: Model): String {
        return "registration"
    }
    //------------------------------------------------------------------------------------------------------------------
    @GetMapping("/contact")
    fun doContact(model: Model): String {
        return "contact"
    }
    //------------------------------------------------------------------------------------------------------------------


















    @GetMapping("/")
    fun index(model: Model): String {
        return "redirect:/view"
    }
    //-----------------------------------------------------------------------------------------------------------------
    @GetMapping("/view")
    fun doView(model: Model): String {
        val vehicles = repVehicle.findByOwnerIdAndDeletedIsNullOrderById(7)
        model.addAttribute("vehicles", vehicles)
        return "view"
    }
    //-----------------------------------------------------------------------------------------------------------------
    @GetMapping("/detailVehicle/{id}")
    fun doDetailVehicle(@PathVariable(name = "id") id: Int, model: Model): String {

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

        return "detailVehicle"
    }
    //-----------------------------------------------------------------------------------------------------------------
    @PostMapping("/consumables")
    @ResponseBody
    fun getConsumablesPage(page_num: Int, id: Int): List<Consumables>? {
        val page: Pageable = PageRequest(page_num - 1, page_size, Sort.Direction.DESC, "replaceDate")
        val obj = repConsumables.findByVehicleId(id, page)
        return obj;
    }
    //-----------------------------------------------------------------------------------------------------------------
    @PostMapping("/spares")
    @ResponseBody
    fun getSparesPage(page_num: Int, id: Int): List<Spares>? {
        val page: Pageable = PageRequest(page_num - 1, page_size, Sort.Direction.DESC, "replaceDate")
        val obj = repSpares.findByVehicleId(id, page)
        return obj;
    }
    //-----------------------------------------------------------------------------------------------------------------
    @PostMapping("/logMessage")
    @ResponseBody
    fun getLogMessagePage(page_num: Int, id: Int): List<LogMessage>? {
        val page: Pageable = PageRequest(page_num - 1, page_size, Sort.Direction.DESC, "lastUpdate")
        val obj = repLog.findByVehicleId(id, page)
        return obj;
    }
    //-----------------------------------------------------------------------------------------------------------------
}

fun getProtocolNameFromCode(code: String?):String {
    var result = ""
    when (code) {
        null -> result = ""
        "000" -> result = "Нет связи прибора с ECU"
        "161" -> result = "SAE J1850 PWM (41.6 kbaud)"
        "162" -> result = "SAE J1850 VPW (10.4 kbaud)"
        "163" -> result = "ISO 9141-2 (5 baud init, 10.4 kbaud)"
        "164" -> result = "ISO 14230-4 KWP (5 baud init, 10.4 kbaud)"
        "165" -> result = "ISO 14230-4 KWP (fast init, 10.4 kbaud)"
        "166" -> result = "ISO 15765-4 CAN (11 bit ID, 500 kbaud)"
        "167" -> result = "ISO 15765-4 CAN (29 bit ID, 500 kbaud)"
        "168" -> result = "ISO 15765-4 CAN (11 bit ID, 250 kbaud)"
        "169" -> result = "ISO 15765-4 CAN (29 bit ID, 250 kbaud)"
        "170" -> result = "SAE J1939 CAN (29 bit ID, 250 kbaud)"
    }
    return result
}

class ApplicationPath(){

    fun get():Path{
        val startupUrl = javaClass.protectionDomain.codeSource.location
        var path: Path? = null
        try {
            path = Paths.get(startupUrl.toURI())
        }
        catch (e: Exception) {
            try {
                path = Paths.get(URL(startupUrl.path).getPath())
            } catch (ipe: Exception) {
                path = Paths.get(startupUrl.path)
            }

        }
        path = path!!.getParent()
        return path
    }

}