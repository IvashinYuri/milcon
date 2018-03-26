package home.milcon.repositories

import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
import home.milcon.models.*
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.Query

@Repository
interface OwnerRepository       : CrudRepository<Owner, Int> {
    fun findOneByEmail(email: String) : Owner?
    fun findOneByActive(active: String) : Owner?
}

@Repository
interface BrandRepository       : CrudRepository<Brand, Int> {
    //fun findDistinctName(): List<Brand>
    //fun findDistinctNameByOrderByNameDesc(): List<Brand>
    @Query("SELECT DISTINCT b.name FROM brand b ORDER BY b.name", nativeQuery = true)
    fun findNames(): List<String>

    @Query("SELECT DISTINCT b.model FROM brand b WHERE b.name = ?1 ORDER BY b.model", nativeQuery = true)
    fun findModels(name: String): List<String>

    @Query("SELECT b.edition FROM brand b WHERE b.name = ?1 AND b.model = ?2 ORDER BY b.model", nativeQuery = true)
    fun findEditions(name: String, model:String): List<String>

    fun findByNameAndModelAndEdition(name: String, model: String, edition: String): Brand
}

@Repository
interface DeviceRepository      : CrudRepository<Device, Int> {
    fun findOneByPid(pid: String) : Device?
}

@Repository
interface VehicleRepository     : CrudRepository<Vehicle, Int> {
    fun findByOwnerIdAndDeletedIsNullOrderById(owner_id: Int): List<Vehicle>?
}

@Repository
interface ConsumablesRepository     : CrudRepository<Consumables, Int> {
    fun countByVehicleId(vehicle_id: Int): Int
    fun findByVehicleId(vehicle_id: Int, page: Pageable): List<Consumables>?
    fun findByVehicleId(vehicle_id: Int): List<Consumables>?
}

@Repository
interface SparesRepository     : CrudRepository<Spares, Int> {
    fun countByVehicleId(vehicle_id: Int): Int
    fun findByVehicleId(vehicle_id: Int, page: Pageable): List<Spares>?
}

@Repository
interface LogRepository         : CrudRepository<LogMessage, Int> {
    fun countByVehicleId(vehicle_id: Int): Int
    fun findByVehicleId(vehicle_id: Int, page: Pageable): List<LogMessage>?
}

@Repository
interface PackInfoRepository    : CrudRepository<PackInfo, Int> {
    fun findOneByPidAndNum(pid: String, num: Int) : PackInfo?
}
@Repository
interface PackDataRepository    : CrudRepository<PackData, Int> {
    fun findOneByPidAndNum(pid: String, num: Int) : PackData?
}
@Repository
interface PackErrorRepository   : CrudRepository<PackError, Int> {
    fun findOneByPidAndNum(pid: String, num: Int) : PackError?
}