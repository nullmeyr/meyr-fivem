$(function() {
    $("#exit").click(function() {
        $(".atm").hide()
        $.post("https://h-core/hideAtm", JSON.stringify("hide"))
    })

    $(".deposit").submit(function() {
        var value = $("#inputDeposit").val()
        if (parseInt(value)) {
            console.log(value)
            $.post("https://h-core/checkDeposit", JSON.stringify(value))
        } else {
            return
        }
    })

    $(".withdraw").submit(function() {
        var value = $("#inputWithdraw").val()
        if (parseInt(value)) {
            $.post("https://h-core/checkWithdraw", JSON.stringify(value))
        } else {
            return
        }
    })

    window.addEventListener('message', (event) => {
        let data = event.data
        if (data.action == "updateHud") {
            $("#cash").text(' $' + event.data.cash.toLocaleString());
            $("#bank").text(' $' + event.data.bank.toLocaleString());  
            console.log("Cash & Bank Updated")
        } 

        if (data.action == "hide") {
            $(".hud").hide() 
            console.log("Money hidden")
        } else if (data.action == "show") {
            $(".hud").show() 
            console.log("Money shown")
        }

        // atm 
        if (data.action == "openAtm") {
            $(".atm").show()
        } 
    })
    
})