package home.milcon.controllers

import home.milcon.models.Owner
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.*
import home.milcon.repositories.*
import home.milcon.services.*
import javax.servlet.http.HttpServletRequest
import java.time.LocalDateTime
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.mail.javamail.MimeMessageHelper
import org.springframework.stereotype.Component
import java.net.URL
import javax.mail.BodyPart
import javax.mail.Multipart
import javax.mail.internet.InternetAddress
import javax.mail.internet.MimeBodyPart
import javax.mail.internet.MimeMessage
import javax.mail.internet.MimeMultipart

@Controller
class SignController {
    @Autowired lateinit var repOwner  : OwnerRepository
    @Autowired val mailSender: MailSender? = null

    //------------------------------------------------------------------------------------------------------------------
    @PostMapping("/signup")
    @ResponseBody
    fun doSignUp(first_name: String, last_name: String, email: String, password: String, timezone: String,
                     model: Model, request: HttpServletRequest): MutableList<String> {

        var message: MutableList<String>
        var owner = repOwner.findOneByEmail(email)
        if(owner != null) {
            message = mutableListOf("false")
            message.add("Ошибка!")
            message.add("Электронный адрес уже зарегистрирован.")
            return message
        }
        try {
            val hash_password = BCrypt.hash(password, 5)
            var hash_active = BCrypt.hash(email + LocalDateTime.now(), 5)
            hash_active = hash_active.replace("/", "")
            hash_active = hash_active.replace(".", "")
            owner = Owner(null, first_name, last_name, email, hash_password, timezone.toInt(), hash_active, 0)
            repOwner.save(owner)
            val requestURL = URL(request.requestURL.toString())
            mailSender!!.sendMail(email, "Активация аккаунта", hash_active,
                    requestURL.getHost() + if(requestURL.getPort() != -1) ":" + requestURL.getPort() else "")
            message = mutableListOf("true")
            message.add("Успешная регистрация!")
            message.add("На ваш электронный адрес отправлено письмо с ссылкой для активации аккаунта.")
            return message
        } catch(e: Exception){
            message = mutableListOf("false")
            message.add("Ошибка!")
            message.add("Программное исключение времени выполнения.")
            return message
        }
    }
    //------------------------------------------------------------------------------------------------------------------
    @GetMapping("/signup/{code}")
    fun doSignUpCode(@PathVariable(name = "code") code: String, model: Model): String {

        var message: MutableList<String>
        val owner = repOwner.findOneByActive(code)
        if(owner != null) {
            if(owner.status == 0) {
                owner.status = 1
                repOwner.save(owner)
                message = mutableListOf("true")
                message.add("Успешная активация!")
                message.add("Ваш аккаунт успешно активирован и вы можете начать работу в системе прямо сейчас.")
            } else {
                message = mutableListOf("true")
                message.add("Ваш аккаунт уже активирован.")
                message.add("Повторная активация учетной записи не требуется.")
            }
        } else {
            message = mutableListOf("false")
            message.add("Неверный код активации!")
            message.add("Попробуйте еще раз перейти по ссылке из полученного вами письма.")
        }
        model.addAttribute("message", message)
        return "activation"
    }
    //------------------------------------------------------------------------------------------------------------------
    @PostMapping("/signin")
    @ResponseBody
    fun doSignIn(login: String, password: String, model: Model, request: HttpServletRequest): MutableList<String> {

        var message: MutableList<String>
        val session = request.getSession(true)
        val owner = repOwner.findOneByEmail(login)
        if(owner != null) {
            if(owner.status == 1) {
                if (BCrypt.verify(password, owner.password)) {
                    message = mutableListOf("true")
                    message.add("/owner/vehicles")
                    session.setAttribute("owner", owner)
                } else {
                    message = mutableListOf("false")
                    message.add("Неверный пароль пользователя.")
                }
            } else {
                message = mutableListOf("false")
                message.add("Учетная запись не активирована.")
            }
        } else {
            message = mutableListOf("false")
            message.add("Неверный email пользователя.")
        }
        return message
    }
    //------------------------------------------------------------------------------------------------------------------
    @Component
    class MailSender {

        @Autowired internal var sender: JavaMailSender? = null
        var message: MimeMessage? = null
        //--------------------------------------------------------------------------------------------------------------
        fun sendMail(to: String, subject: String, link: String, host: String) {
            val fullText = "http://" + host + "/signup/" + link
            val html = "<p>Здравствуйте!</p>" +
                    "<p>Чтобы подтвердить регистрацию на сайте, перейдите по  <a href=" + fullText + ">этой ссылке</a>.</p>" +
                    "<p style='color: #aeabb2; font-size: 85%; font-style: italic;'>или введите в окне браузера <br>" + fullText + "</p>"
            message = sender!!.createMimeMessage()
            val helper = MimeMessageHelper(message)
            helper.setFrom("milcon@ledmon.ru")
            helper.setTo(to)
            helper.setSubject(subject)
            val multipart: Multipart = MimeMultipart()
            val htmlPart: BodyPart = MimeBodyPart()
            htmlPart.setContent(html,"text/html; charset=utf-8")
            htmlPart.setDisposition(BodyPart.INLINE)
            multipart.addBodyPart(htmlPart)
            message!!.setContent(multipart)
            val thread =  Thread(this::threadSendMail).start()
        }
        //--------------------------------------------------------------------------------------------------------------
        private fun threadSendMail() {
            sender!!.send(message)
        }
    }
    //------------------------------------------------------------------------------------------------------------------


}