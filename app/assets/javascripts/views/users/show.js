(function(){

    // Init the Users module here
    this.Terraling = this.Terraling || {};
    this.Terraling["Users::Users"] = this.Terraling["Users::Users"] || {};

    var users = this.Terraling["Users::Users"];

    users.show = {
        init: initPage
    };

    var userteams;
    var otherteams;
    
    var remove;
    
    var currentTeamContainer;
    var otherTeamContainer;

    function initPage() {
        console.log("HELLO");

        userteams = JSON.parse(document.getElementById("userteam-list").value);

        otherteams = JSON.parse(document.getElementById("otherteam-list").value);

        currentTeamContainer = document.getElementById("list");
        otherTeamContainer = document.getElementById("append");

        updateLists();

        var append = document.getElementById("append-button");

        append.addEventListener('click', (e) => {
            e.preventDefault();

            if (otherteams.length === 0) { return; }

            var selectedName = otherTeamContainer.options[otherTeamContainer.selectedIndex].value;

            var selectedObject = {};

            otherteams = otherteams.reduce((arr, ot) => {
                if (ot.name === selectedName) {
                    selectedObject = ot;
                } else {
                    arr.push(ot);
                }

                return arr;
            }, []);

            userteams.push(selectedObject);

            updateLists();
        });
    }

    function updateLists() {
        if (otherteams.length == 0) {
            otherTeamContainer.setAttribute("disabled", true);
        } else {
            otherTeamContainer.removeAttribute("disabled");
        }

        while (currentTeamContainer.children.length > 1) {
            currentTeamContainer.removeChild(currentTeamContainer.firstChild);
        }

        userteams.forEach((ut) => {
            var input = document.createElement("input");
            input.classList.add("form-control", "input-md");
            input.value = ut.name;
            input.setAttribute("readonly","");

            var hidden = document.createElement("input");
            hidden.setAttribute("hidden", "true");
            hidden.setAttribute("name", "userteams[]");
            hidden.value = ut.id;


            var button = document.createElement("button");
            button.classList.add("btn", "btn-danger");
            button.innerHTML = '<i class="fa fa-trash"></i>';
            button.setAttribute("type", "button");

            var span = document.createElement("span");
            span.classList.add("input-group-btn", "remove-btn");

            var div = document.createElement("div");
            div.classList.add("input-group");
            
            span.prepend(button);

            div.prepend(hidden);
            div.prepend(span);
            div.prepend(input);

            currentTeamContainer.prepend(div);
        })

        otherTeamContainer.innerHTML = "";

        otherteams.forEach((ot) => {
            var option = document.createElement("option");
            option.appendChild(document.createTextNode(ot.name));

            otherTeamContainer.prepend(option);
        })

        remove = document.querySelectorAll(".remove-btn");

        remove.forEach((removeBtn) => {
            removeBtn.addEventListener('click', (e) => {
                console.log('wtf');
                e.preventDefault();

                var matchingInput = removeBtn.parentElement.querySelector("input");

                var selectedName = matchingInput.value;

                var selectedObject = {};

                userteams = userteams.reduce((arr, ut) => {
                    if (ut.name === selectedName) {
                        selectedObject = ut;
                    } else {
                        arr.push(ut);
                    }
    
                    return arr;
                }, []);
    
                otherteams.push(selectedObject);
    
                updateLists();
            });
        });
    }

})();
