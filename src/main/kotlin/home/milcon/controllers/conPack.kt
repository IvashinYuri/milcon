package home.milcon.controllers

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*
import home.milcon.models.*
import home.milcon.repositories.*
import home.milcon.services.CustomException
import java.time.Duration
import java.time.LocalDateTime


@RestController
@RequestMapping("/5E095FBE-2F3D-499A-9AC9-01A1B5CE86C7")
class PackController {
    @Autowired lateinit var repPackInfo:        PackInfoRepository
    @Autowired lateinit var repPackData:        PackDataRepository
    @Autowired lateinit var repPackError:       PackErrorRepository
    @Autowired lateinit var repLog:             LogRepository
    @Autowired lateinit var repDevice:          DeviceRepository
    @Autowired lateinit var repConsumables:     ConsumablesRepository
    //------------------------------------------------------------------------------------------------------------------
    @GetMapping("/info")
    fun setPackInfo(pid: String, num: Int, vin: String, protocol: String, balance: String): String {
        var result: String
        try {
            val device = repDevice.findOneByPid(pid)
            if (device != null && device.vehicle?.id != null) {
                val local_time = LocalDateTime.now()
                val pack = repPackInfo.findOneByPidAndNum(pid, num)
                repPackInfo.save(PackInfo(  id = pack?.id, pid = pid, num = num, vin = vin,
                                            protocol = protocol, balance = balance, update = local_time))
                device.balance = balance
                device.vehicle?.vin = vin
                device.vehicle?.protocol = protocol
                repDevice.save(device)
                val protocol_text = getProtocolNameFromCode(protocol)
                repLog.save(LogMessage(vehicleId = device.vehicle?.id, type = LogType(id = 1), lastUpdate = local_time,
                        message = (if(pack == null) "" else "Повторно. ") + "Протокол : ${protocol_text}. Баланс : ${balance} руб."))
                result = "NORMAL"
            }else {
                throw CustomException("Device or vehicle not found")
            }
        } catch(e: Exception){
            result = "ERROR"
        }
        return result
    }
    //-----------------------------------------------------------------------------------------------------------------
    @GetMapping("/data")
    fun setPackData(pid: String, num: Int, mileage: Int, balance: String): String {
        var result: String
        try {
            val device = repDevice.findOneByPid(pid)
            if (device != null && device.vehicle?.id != null) {
                val local_time = LocalDateTime.now()
                val pack = repPackData.findOneByPidAndNum(pid, num)
                device.balance = balance
                device.vehicle?.mileage = device.vehicle?.mileage!! - (pack?.mileage?:0) + mileage
                repDevice.save(device)
                repPackData.save(PackData(id = pack?.id, pid = pid, num = num, mileage = mileage,
                        balance = balance, update = local_time))
                val common_mileage: Float = (device.vehicle?.mileage!! / 1000.0f)
                repLog.save(LogMessage(vehicleId = device.vehicle?.id, type = LogType(id = 2), lastUpdate = local_time,
                        message = (if(pack == null) "" else "Повторно. ") + "Дельта-одометр : ${mileage} м. Общий пробег : ${common_mileage} км. Баланс : ${balance} руб."))

                val listConsumables = repConsumables.findByVehicleId(device.vehicle?.id!!)
                for(item in listConsumables.orEmpty()){
                    /*var value: Int? = null
                    if(item.resource_mileage != null && item.replace_mileage != null)
                        value = 100 - ((common_mileage - item.replace_mileage!!) / item.resource_mileage!! * 100).toInt()
                    item.remainder_mileage = value
                    repConsumables.save(item)*/
                }

                result = "NORMAL"
            }else {
                throw CustomException("Device or vehicle not found")
            }
        } catch(e: Exception){
            result = "ERROR"
        }
        return result
    }
    //------------------------------------------------------------------------------------------------------------------
    @GetMapping("/error")
    fun setPackError(pid: String, num: Int, error: String, balance: String): String {
        var result: String
        try {
            val device = repDevice.findOneByPid(pid)
            if (device != null && device.vehicle?.id != null) {
                val local_time = LocalDateTime.now()
                val pack = repPackError.findOneByPidAndNum(pid, num)
                repPackError.save(PackError(id = pack?.id, pid = pid, num = num, error = error,
                                            balance = balance, update = local_time))
                device.balance = balance
                repDevice.save(device)
                repLog.save(LogMessage(vehicleId = device.vehicle?.id, type = LogType(id = 3), lastUpdate = local_time,
                        message = (if(pack == null) "" else "Повторно. ") + "Код : ${error}. Баланс : ${balance} руб."))
                result = "NORMAL"
            }else {
                throw CustomException("Device or vehicle not found")
            }
        } catch(e: Exception){
            result = "ERROR"
        }
        return result
    }
    //------------------------------------------------------------------------------------------------------------------
    fun getTimeToNearMidnight(): Long {
        val now: LocalDateTime = LocalDateTime.now()
        val target: LocalDateTime = if (now.hour >= 23 && now.minute >= 30) {
            LocalDateTime.of(now.year, now.month, now.dayOfMonth + 1, 23, 30, 0, 0)
        } else {
            LocalDateTime.of(now.year, now.month, now.dayOfMonth, 23, 30, 0, 0)
        }
        val result = Duration.between(now, target).getSeconds()
        return result
    }
    //-----------------------------------------------------------------------------------------------------------------

}