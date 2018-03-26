package home.milcon.controllers

import com.google.gson.GsonBuilder
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.*
import home.milcon.models.Brand
import home.milcon.repositories.BrandRepository

@Controller
@RequestMapping("/1D75073D-75CD-4F7C-A6BF-01465A32ED41")
class AdminController {

    @Autowired lateinit var repBrand  : BrandRepository

    @GetMapping("")
    fun viewAdmin(model: Model): String {
        val objBrandList = repBrand.findAll()
        model.addAttribute("objBrandList", objBrandList)
        model.addAttribute("pathAdmin", "1D75073D-75CD-4F7C-A6BF-01465A32ED41")
        return "admin"
    }
    //------------------------------------------------------------------------------------------------------------------
    @PostMapping("/addBrand")
    @ResponseBody
    fun addBrand(@RequestBody jsonBrand: String): Iterable<Brand> {
        val objGson     = GsonBuilder().setPrettyPrinting().create()
        val objBrand  = objGson.fromJson(jsonBrand, Brand::class.java)
        repBrand.save(objBrand)
        return repBrand.findAll()
    }
    //------------------------------------------------------------------------------------------------------------------
    @GetMapping("/editBrand{id}")
    @ResponseBody
    fun getBrandById(id: Int): Brand {
        return repBrand.findOne(id)
    }
    //------------------------------------------------------------------------------------------------------------------
    @PutMapping("/editBrand")
    @ResponseBody
    fun editBrand(@RequestBody jsonBrand: String): Iterable<Brand> {
        val objGson   = GsonBuilder().setPrettyPrinting().create()
        val objBrand  = objGson.fromJson(jsonBrand, Brand::class.java)
        repBrand.save(objBrand)
        return repBrand.findAll()
    }
    //------------------------------------------------------------------------------------------------------------------
    @PostMapping("/delBrand")
    @ResponseBody
    fun delBrand(id: Int):Iterable<Brand>{
        repBrand.delete(id)
        return repBrand.findAll()
    }
}