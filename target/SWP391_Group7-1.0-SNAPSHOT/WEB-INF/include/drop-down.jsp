<%-- 
    Document   : drop-down
    Created on : Jun 17, 2025, 8:28:36 AM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@ page pageEncoding="UTF-8" %>
<style>
    .accordion {
        background-color: white;
        color: #444;
        cursor: pointer;
        padding: 5px;
        width: 100%;
        border: none;
        text-align: left;
        outline: none;
        font-size: 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        transition: 0.4s;
    }

    .panel {
        padding: 0 18px;
        background-color: white;
        max-height: 0;
        overflow: hidden;
        transition: max-height 0.3s ease-out;
    }

    /* Custom arrow icon */
    .arrow {
        border: solid #444;
        border-width: 0 2px 2px 0;
        display: inline-block;
        padding: 3px;
        margin-bottom: 3px;
        transform: rotate(45deg); /* up */
        transition: transform 0.3s ease;
    }

    .accordion.active .arrow {
        transform: rotate(-135deg); /* down */
        margin-bottom: -10px;
    }

    .title {
        margin-left: -3px;
    }
    
</style>

    <hr>
    <button type="button" class="accordion">
        <span class="title">Thương hiệu</span>
        <span class="arrow"></span>
    </button>
    <div class="panel">
        <label><input type="checkbox" name="brand" value="Acer"> Acer</label><br>
        <label><input type="checkbox" name="brand" value="Asus"> Asus</label><br>
        <label><input type="checkbox" name="brand" value="Dell"> Dell</label><br>
        <label><input type="checkbox" name="brand" value="HP"> HP</label><br>
        <label><input type="checkbox" name="brand" value="Other"> Khác</label><br>
        <label><input type="checkbox" name="brand" value="Lenovo"> Lenovo</label>
    </div>

    <hr>
    <button type="button" class="accordion">
        <span class="title">Loại hàng</span>
        <span class="arrow"></span>
    </button>
    <div class="panel">
        <label><input type="checkbox" name="type" 
                      value="discounted-inventory"> Hàng thanh lý</label><br>
        <label><input type="checkbox" name="type" 
                      value="normal-inventory"> Hàng thông thường</label>
    </div>

    <hr>
    <button type="button" class="accordion">
        <span class="title">Series</span>
        <span class="arrow"></span>
    </button>
    <div class="panel">
        <label><input type="checkbox" name="series" value="Aspire"> Aspire</label><br>
        <label><input type="checkbox" name="series" value="EliteMini"> Elite Mini</label><br>
        <label><input type="checkbox" name="series" value="IdeaCenter"> IdeaCenter</label><br>
        <label><input type="checkbox" name="series" value="Inspiron"> Inspiron</label><br>
        <label><input type="checkbox" name="series" value="NUC"> NUC</label><br>
        <label><input type="checkbox" name="series" value="Optiplex"> Optiplex</label><br>
        <label><input type="checkbox" name="series" value="Pavilion"> Pavilion</label><br>
        <label><input type="checkbox" name="series" value="AMD"> AMD</label><br>
        <label><input type="checkbox" name="series" value="Intel"> Intel</label><br>
        <label><input type="checkbox" name="series" value="Precision"> Precision</label><br>
        <label><input type="checkbox" name="series" value="ProMini"> Pro Mini</label><br>
        <label><input type="checkbox" name="series" value="ProDesk"> ProDesk</label>
    </div>

    <hr>
    <button type="button" class="accordion">
        <span class="title">Nhu cầu</span>
        <span class="arrow"></span>
    </button>
    <div class="panel">
        <label><input type="checkbox" name="need" value="Gaming"> Gaming</label><br>
        <label><input type="checkbox" name="need" value="Student"> Học sinh - Sinh viên</label><br>
        <label><input type="checkbox" name="need" value="Office"> Văn phòng</label>
    </div>

    <hr>
    <button type="button" class="accordion">
        <span class="title">PC Segment</span>
        <span class="arrow"></span>
    </button>
    <div class="panel">
        <label><input type="checkbox" name="pc_segment" value="PCAI"> PC AI</label><br>
        <label><input type="checkbox" name="pc_segment" value="PCGaming"> PC Gaming</label><br>
        <label><input type="checkbox" name="pc_segment" value="PCMini"> PC Mini</label><br>
        <label><input type="checkbox" name="pc_segment" value="PCOffice"> PC Văn phòng</label>
    </div>

    <hr>
    <button type="button" class="accordion">
        <span class="title">Series CPU</span>
        <span class="arrow"></span>
    </button>
    <div class="panel">
        <label><input type="checkbox" name="series_cpu" value="N"> Core N</label><br>
        <label><input type="checkbox" name="series_cpu" value="I3"> Core i3</label><br>
        <label><input type="checkbox" name="series_cpu" value="I5"> Core i5</label><br>
        <label><input type="checkbox" name="series_cpu" value="I7"> Core i7</label><br>
        <label><input type="checkbox" name="series_cpu" value="I9"> Core i9</label><br>
        <label><input type="checkbox" name="series_cpu" value="R3"> Ryzen 3</label><br>
        <label><input type="checkbox" name="series_cpu" value="R5"> Ryzen 5</label><br>
        <label><input type="checkbox" name="series_cpu" value="R7"> Ryzen 7</label><br>
        <label><input type="checkbox" name="series_cpu" value="U7"> Ultra 7</label><br>
        <label><input type="checkbox" name="series_cpu" value="U9"> Ultra 9</label>
    </div>

    <hr>
    <button type="button" class="accordion">
        <span class="title">Thế hệ CPU</span>
        <span class="arrow"></span>
    </button>
    <div class="panel">
        <label><input type="checkbox" name="cpu_gen" value="AMD4000S"> AMD 4000 series</label><br>
        <label><input type="checkbox" name="cpu_gen" value="AMD5000S"> AMD 5000 series</label><br>
        <label><input type="checkbox" name="cpu_gen" value="AMD7000S"> AMD 7000 series</label><br>
        <label><input type="checkbox" name="cpu_gen" value="AMD9000S"> AMD 9000 series</label><br>
        <label><input type="checkbox" name="cpu_gen" value="AMDRyG3"> AMD Ryzen Gen 3</label><br>
        <label><input type="checkbox" name="cpu_gen" value="IntelCoreU200S"> Intel Core Ultra 200S</label><br>
        <label><input type="checkbox" name="cpu_gen" value="IntelCoreUS2"> Intel Core Ultra series 2</label><br>
        <label><input type="checkbox" name="cpu_gen" value="IntelCoreG10"> Intel Core Gen 10</label><br>
        <label><input type="checkbox" name="cpu_gen" value="IntelCoreG12"> Intel Core Gen 12</label><br>
        <label><input type="checkbox" name="cpu_gen" value="IntelCoreG13"> Intel Core Gen 13</label><br>
        <label><input type="checkbox" name="cpu_gen" value="IntelCoreG14"> Intel Core Gen 14</label><br>
        <label><input type="checkbox" name="cpu_gen" value="IntelCoreG8"> Intel Core Gen 8</label>
    </div>

    <hr>
    <button type="button" class="accordion">
        <span class="title">RAM</span>
        <span class="arrow"></span>
    </button>
    <div class="panel">
        <label><input type="checkbox" name="ram" value="16GB"> 16GB</label><br>
        <label><input type="checkbox" name="ram" value="32GB"> 32GB</label><br>
        <label><input type="checkbox" name="ram" value="48GB"> 48GB</label><br>
        <label><input type="checkbox" name="ram" value="64GB"> 64GB</label><br>
        <label><input type="checkbox" name="ram" value="8GB"> 8GB</label>
    </div>

    <hr>
    <button type="button" class="accordion">
        <span class="title">Đồ họa rời</span>
        <span class="arrow"></span>
    </button>
    <div class="panel">
        <label><input type="checkbox" name="graphics_card" value="GTX1650"> GeForce GTX 1650</label><br>
        <label><input type="checkbox" name="graphics_card" value="GTX1660S"> GeForce GTX 1660 Super</label><br>
        <label><input type="checkbox" name="graphics_card" value="RTX3050"> GeForce RTX 3050</label><br>
        <label><input type="checkbox" name="graphics_card" value="RTX3060"> GeForce RTX 3060</label><br>
        <label><input type="checkbox" name="graphics_card" value="RTX4060"> GeForce RTX 4060</label><br>
        <label><input type="checkbox" name="graphics_card" value="RTX4070S"> GeForce RTX 4070S</label><br>
        <label><input type="checkbox" name="graphics_card" value="RTX4080S"> GeForce RTX 4080S</label><br>
        <label><input type="checkbox" name="graphics_card" value="RTX4090"> GeForce RTX 4090</label><br>
        <label><input type="checkbox" name="graphics_card" value="RTX5060"> GeForce RTX 5060</label><br>
        <label><input type="checkbox" name="graphics_card" value="RTX5060Ti"> GeForce RTX 5060Ti</label><br>
        <label><input type="checkbox" name="graphics_card" value="RTX5070"> GeForce RTX 5070</label><br>
        <label><input type="checkbox" name="graphics_card" value="RTX5070Ti"> GeForce RTX 5070Ti</label><br>
        <label><input type="checkbox" name="graphics_card" value="RTX5080"> GeForce RTX 5080</label><br>
        <label><input type="checkbox" name="graphics_card" value="RTX5090"> GeForce RTX 5090</label><br>
        <label><input type="checkbox" name="graphics_card" value="QT400"> Quadro T400</label><br>
        <label><input type="checkbox" name="graphics_card" value="RRX6500XT"> Radeon RX 6500 XT</label><br>
        <label><input type="checkbox" name="graphics_card" value="RRX6500XT"> Radeon RX 6500 XT</label>
    </div>

    <hr>
    <button type="button" class="accordion">
        <span class="title">Dung lượng SSD</span>
        <span class="arrow"></span>
    </button>
    <div class="panel">
        <label><input type="checkbox" name="ssd_capacity" value="1TB"> 1TB</label><br>
        <label><input type="checkbox" name="ssd_capacity" value="256GB"> 256GB</label><br>
        <label><input type="checkbox" name="ssd_capacity" value="256GB+1TB"> 256GB+1TB</label><br>
        <label><input type="checkbox" name="ssd_capacity" value="512GB"> 512GB</label><br>
        <label><input type="checkbox" name="ssd_capacity" value="None"> Trống</label>
    </div>

    <hr>
    <button type="button" class="accordion">
        <span class="title">Hệ điều hành</span>
        <span class="arrow"></span>
    </button>
    <div class="panel">
        <label><input type="checkbox" name="os" value="Window"> Window</label><br>
        <label><input type="checkbox" name="os" value="MacOS"> MacOS</label>
    </div>


<script>
    const accordions = document.querySelectorAll(".accordion");

    accordions.forEach(acc => {
        acc.addEventListener("click", function () {
            this.classList.toggle("active");
            const panel = this.nextElementSibling;

            if (panel.style.maxHeight) {
                panel.style.maxHeight = null;
            } else {
                panel.style.maxHeight = panel.scrollHeight + "px";
            }
        });
    });
</script>
