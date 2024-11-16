import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['selectedRegionId', 'selectedProvinceId', 'selectedCityId', 'selectedBarangayId']

    fetchProvinces(){
        let target = this.selectedProvinceIdTarget
        $(target).empty();

        let defaultOption = document.createElement("option");
        defaultOption.value = "";
        defaultOption.text = "Please select province";
        target.appendChild(defaultOption);

        $.ajax({
        type: 'GET',
        url: '/api/v1/regions/' + this.selectedRegionIdTarget.value + '/provinces',
        dataType: 'json',
        success: (response) => {
        console.log(response)
        $.each(response, function (index, record) {
            let option = document.createElement('option')
            option.value = record.id
            option.text = record.name
            target.appendChild(option)
            })
        }
        })
    }
    fetchCities(){
        let target = this.selectedCityIdTarget
        $(target).empty();

        let defaultOption = document.createElement("option");
        defaultOption.value = "";
        defaultOption.text = "Please select city";
        target.appendChild(defaultOption);

        $.ajax({
            type: 'GET',
            url: '/api/v1/provinces/' + this.selectedProvinceIdTarget.value + '/cities',
            dataType: 'json',
            success: (response) => {
                console.log(response)
                $.each(response, function (index, record) {
                    let option = document.createElement('option')
                    option.value = record.id
                    option.text = record.name
                    target.appendChild(option)
                })
            }
        })
    }
    fetchBarangays(){
        let target = this.selectedBarangayIdTarget
        $(target).empty();

        let defaultOption = document.createElement("option");
        defaultOption.value = "";
        defaultOption.text = "Please select barangay";
        target.appendChild(defaultOption);

        $.ajax({
            type: 'GET',
            url: '/api/v1/cities/' + this.selectedCityIdTarget.value + '/barangays',
            dataType: 'json',
            success: (response) => {
                console.log(response)
                $.each(response, function (index, record) {
                    let option = document.createElement('option')
                    option.value = record.id
                    option.text = record.name
                    target.appendChild(option)
                })
            }
        })
    }
}
