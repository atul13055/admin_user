//= require active_admin/base
//= require activeadmin/quill_editor/quill
//= require activeadmin/quill_editor_input
// app/javascript/packs/form.js

// app/javascript/packs/form.js

document.addEventListener("DOMContentLoaded", function () {
  const countryField = document.querySelector("#user_country");
  const stateField = document.querySelector("#user_state");
  const cityField = document.querySelector("#user_city");
  const otherCityWrapper = document.querySelector("#other_city_wrapper");
  const otherCityInput = document.querySelector("#user_other_city");

  // Ensure fields exist before attaching event listeners
  if (countryField && stateField && cityField) {
    
    // Fetch states when country changes
    countryField.addEventListener("change", function () {
      const countryCode = countryField.value;

      fetch(`/get_states?country=${countryCode}`)
        .then(response => response.json())
        .then(states => {
          stateField.innerHTML = '<option value="">Select State</option>';
          states.forEach(state => {
            let option = document.createElement("option");
            option.value = state.code;
            option.textContent = state.name;
            stateField.appendChild(option);
          });

          // After updating states, clear cities and reset "Other" input
          cityField.innerHTML = '<option value="">Select City</option>';
          otherCityWrapper.classList.add("d-none");
          otherCityInput.removeAttribute("required");
        })
        .catch(error => console.error('Error fetching states:', error));
    });

    // Fetch cities when state changes
    stateField.addEventListener("change", function () {
      const countryCode = countryField.value;
      const stateCode = stateField.value;

      fetch(`/get_cities?country=${countryCode}&state=${stateCode}`)
        .then(response => response.json())
        .then(cities => {
          cityField.innerHTML = '<option value="">Select City</option>';
          cities.forEach(city => {
            let option = document.createElement("option");
            option.value = city;
            option.textContent = city;
            cityField.appendChild(option);
          });

          // Add "Other" option
          let otherOption = document.createElement("option");
          otherOption.value = "Other";
          otherOption.textContent = "Other";
          cityField.appendChild(otherOption);
        })
        .catch(error => console.error('Error fetching cities:', error));
    });

    // Show/hide "Other City" input field based on city selection
    cityField.addEventListener("change", function () {
      if (cityField.value === "Other") {
        otherCityWrapper.classList.remove("d-none");
        otherCityInput.setAttribute("required", "true");
      } else {
        otherCityWrapper.classList.add("d-none");
        otherCityInput.removeAttribute("required");
      }
    });
  }
});


document.addEventListener("DOMContentLoaded", function() {
  const updatePasswordCheckbox = document.getElementById("user_update_password");
  const passwordFields = document.querySelectorAll(".password-field");

  // Initially disable password fields
  if (!updatePasswordCheckbox.checked) {
    passwordFields.forEach(function(field) {
      field.disabled = true; // Disable password fields initially
    });
  }

  // Enable/Disable password fields based on checkbox state
  updatePasswordCheckbox.addEventListener('change', function() {
    passwordFields.forEach(function(field) {
      field.disabled = !updatePasswordCheckbox.checked; // Enable if checked, disable if unchecked
    });
  });
});
