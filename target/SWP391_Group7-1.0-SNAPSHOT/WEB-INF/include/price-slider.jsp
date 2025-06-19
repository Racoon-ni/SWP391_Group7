<%-- 
    Document   : price-slider
    Created on : Jun 17, 2025, 6:31:27 PM
    Author     : Huynh Trong Nguyen - CE190356
--%>

<%@ page pageEncoding="UTF-8" %>
<style>
    .slider-container {
        width: 280px;
        position: relative;
    }

    .range-slider {
        position: relative;
    }

    .slider-track {
        position: absolute;
        height: 2px;
        background: #ccc;
        top: 50%;
        transform: translateY(-50%);
        width: 100%;
        border-radius: 4px;
    }

    .slider-range {
        position: absolute;
        height: 4px;
        background: blue;
        top: 50%;
        transform: translateY(-50%);
        border-radius: 4px;
    }

    input[type=range] {
        -webkit-appearance: none;
        position: absolute;
        width: 100%;
        top: -1px;
        height: 3px;
        background: none;
        pointer-events: none;
    }

    input[type=range]::-webkit-slider-thumb {
        -webkit-appearance: none;
        pointer-events: all;
        width: 16px;
        height: 16px;
        border-radius: 50%;
        border: 2px solid blue;
        cursor: pointer;
        position: relative;
        z-index: 3;
        background-color: white;
    }

    input[type=range]::-moz-range-thumb {
        pointer-events: all;
        width: 16px;
        height: 16px;
        border-radius: 50%;
        background: #4caf50;
        border: 2px solid white;
        cursor: pointer;
    }

    .value-labels {
        text-align: center;
        margin-top: 10px;
        font-family: sans-serif;
    }

    .value-box {
        display: inline-block;
        padding: 6px 12px;
        min-width: 120px; /* or set a fixed width like width: 120px */
        text-align: center;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-weight: bold;
        background-color: white;
    }
</style>
</head>
<body>

    <div class="slider-container" style="margin-bottom: 40px">

        <div class="value-labels">

            <div style="display: flex; align-items: center; margin-bottom: 20px">
                <div class="value-box">
                    <span id="min-val">đ</span>
                </div>

                <!-- The connecting line -->
                <div style="flex-grow: 1; height: 1px; background-color: #ccc;"></div>

                <div class="value-box">
                    <span id="max-val">đ</span>
                </div>
            </div>

        </div>

        <div class="range-slider">
            <div class="slider-track"></div>
            <div class="slider-range" id="slider-range"></div>
            <input type="range" name="range-min" id="range-min" min="0" max="190000000" value="0" step="500000">
            <input type="range" name="range-max" id="range-max" min="0" max="190000000" value="190000000" step="500000">

        </div>
    </div>
    
<script>
        const minRange = document.getElementById("range-min");
        const maxRange = document.getElementById("range-max");
        const rangeBar = document.getElementById("slider-range");
        const minValText = document.getElementById("min-val");
        const maxValText = document.getElementById("max-val");
        const minGap = 1;

        // Currency formatter function
        function formatCurrency(value) {
            return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".") + 'đ';
        }

        function updateSlider(event) {
            let minVal = parseInt(minRange.value);
            let maxVal = parseInt(maxRange.value);

            if (maxVal - minVal < minGap) {
                if (event && event.target === minRange) {
                    minRange.value = maxVal - minGap;
                    minVal = maxVal - minGap;
                } else {
                    maxRange.value = minVal + minGap;
                    maxVal = minVal + minGap;
                }
            }

            // ✅ Format and display currency values
            minValText.textContent = formatCurrency(minVal);
            maxValText.textContent = formatCurrency(maxVal);

            // ✅ Update range bar position
            const range = minRange.max - minRange.min;
            const left = ((minVal - minRange.min) / range) * 100;
            const right = ((maxVal - minRange.min) / range) * 100;

            rangeBar.style.left = left + "%";
            rangeBar.style.width = (right - left) + "%";
        }

        minRange.addEventListener("input", updateSlider);
        maxRange.addEventListener("input", updateSlider);
        window.addEventListener("DOMContentLoaded", updateSlider);
</script>
