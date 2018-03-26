package home.milcon.models

import com.fasterxml.jackson.annotation.JsonBackReference
import com.fasterxml.jackson.annotation.JsonManagedReference
import java.sql.Date
import java.sql.Timestamp
import java.time.LocalDate
import java.time.LocalDateTime
import javax.persistence.*
import javax.persistence.AttributeConverter

@Entity
@Table(name = "owner")
data class Owner(
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        val id: Int? = null,
        var first_name: String = "",
        var last_name: String = "",
        var email: String = "",
        var password: String = "",
        var timezone: Int = 0,
        var active: String = "",
        var status: Int = 0
        //@OneToMany(mappedBy = "owner", fetch = FetchType.LAZY)
        //@JsonBackReference
        //var vehicles: List<Vehicle>? = null
)

@Entity
@Table(name = "brand")
data class Brand(
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        val id: Int? = null,
        var name: String = "",
        var model: String = "",
        var edition: String = "",
        var photo: String = "",
        @OneToMany(mappedBy = "brand", fetch = FetchType.LAZY)
        @JsonBackReference
        var vehicles: List<Vehicle>? = null
)

@Entity
@Table(name = "device")
data class Device(
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        val id: Int? = null,
        var pid: String = "",
        var balance: String = "",
        @OneToOne(mappedBy = "device", cascade = arrayOf(CascadeType.ALL), fetch = FetchType.LAZY)
        @JsonBackReference
        var vehicle: Vehicle? = null
)

@Entity
@Table(name = "vehicle")
data class Vehicle(
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        val id: Int? = null,
        //@ManyToOne(cascade = arrayOf(CascadeType.ALL), fetch = FetchType.LAZY)
        //@JoinColumn(name = "owner_id")
        //@JsonManagedReference
        //var owner: Owner? = null,
        @Column(name = "owner_id")
        var ownerId: Int? = null,


        @ManyToOne(cascade = arrayOf(CascadeType.ALL), fetch = FetchType.LAZY)
        @JoinColumn(name = "brand_id")
        @JsonManagedReference
        var brand: Brand? = null,
        @OneToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "device_id")
        @JsonManagedReference
        var device: Device? = null,
        var vin: String = "VIN00000000000000",
        var protocol: String? = null,
        var mileage: Int = 0,
        var photo: String? = null,
        var deleted: LocalDateTime? = null
)

@Entity
@Table(name = "consumables")
data class Consumables(
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        val id: Int? = null,
        @Column(name = "vehicle_id")
        var vehicleId: Int = 0,
        var name: String = "",
        @Column(name = "replace_date")
        var replaceDate: LocalDate? = null,
        @Column(name = "replace_mileage")
        var replaceMileage: Int? = null,
        var brand: String? = null,
        var model: String? = null,
        @Column(name = "resource_date")
        var resourceDate: Int? = null,
        @Column(name = "resource_mileage")
        var resourceMileage: Int? = null
)

@Entity
@Table(name = "spares")
data class Spares(
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        val id: Int? = null,
        @Column(name = "vehicle_id")
        var vehicleId: Int = 0,
        var name: String = "",
        @Column(name = "replace_date")
        var replaceDate: LocalDate? = null,
        @Column(name = "replace_mileage")
        var replaceMileage: Int? = null,
        var brand: String? = null,
        var model: String? = null
)

@Entity
@Table(name = "log_type")
data class LogType(
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        val id: Int? = null,
        var name: String = ""
)
@Entity
@Table(name = "log_message")
data class LogMessage(
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        val id: Int? = null,
        @Column(name = "vehicle_id")
        val vehicleId: Int? = null,
        @ManyToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "type_id")
        @JsonManagedReference
        var type: LogType? = null,
        var message: String = "",
        @Column(name = "update")
        var lastUpdate: LocalDateTime = LocalDateTime.now()
)

@Entity
@Table(name = "pack_info")
data class PackInfo(
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        val id: Int? = null,
        var pid: String = "",
        var num: Int = 0,
        var vin: String = "",
        var protocol: String = "",
        var balance: String = "",
        var update: LocalDateTime = LocalDateTime.now()
)
@Entity
@Table(name = "pack_data")
data class PackData(
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        val id: Int? = null,
        var pid: String = "",
        var num: Int = 0,
        var mileage: Int = 0,
        var balance: String = "",
        var update: LocalDateTime = LocalDateTime.now()
)
@Entity
@Table(name = "pack_error")
data class PackError(
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        val id: Int? = null,
        var pid: String = "",
        var num: Int = 0,
        var error: String = "",
        var balance: String = "",
        var update: LocalDateTime = LocalDateTime.now()
)

@Converter(autoApply = true)
class LocalDateTimeConverter : AttributeConverter<LocalDateTime, Timestamp> {

    override fun convertToDatabaseColumn(localDateTime: LocalDateTime?): Timestamp? {
            return if (localDateTime == null) null else Timestamp.valueOf(localDateTime)
    }
    override fun convertToEntityAttribute(timestamp: Timestamp?): LocalDateTime? {
            return if (timestamp == null) null else timestamp.toLocalDateTime()
    }
}

@Converter(autoApply = true)
class LocalDateConverter : AttributeConverter<LocalDate, Date> {

    override fun convertToDatabaseColumn(localDate: LocalDate?): Date? {
        return if (localDate == null) null else Date.valueOf(localDate)
    }
    override fun convertToEntityAttribute(date: Date?): LocalDate? {
        return if (date == null) null else date.toLocalDate()
    }
}
