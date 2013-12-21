app = angular.module("SpaceRadar", ["ngResource"])
app.config( ($httpProvider) -> 
    delete $httpProvider.defaults.headers.common['X-Requested-With']
)

@SpaceRadarCtrl = ($scope, $resource, $timeout) ->
	SpaceApi = $resource("http://spaceapi.n39.eu/json")
	status = SpaceApi.get();
	angular.forEach status, (k) ->
        alert("Key is " + k + " value is" + status[k]);

	$scope.satellites = [
		{
			name: "Hegel", 
			visible:true, 
			type:"curl", 
			openUrl:"/wake_on_lan/create.json", 
			closeUrl:"/wake_on_lan/destroy.json",
			checkUrl: "wake_on_lan/show.json",
			status:{open:true}, 
			pos:[275,500]
		}
		{
			name: "Ampel", 
			visible:true, 
			type:"curl", 
			status:status, 
			openUrl:"http://wittgenstein/open", 
			closeUrl:"http://wittgenstein/close", 
			pos:[25,450]
		}
		{	
			name: "Fräse",
			visible:true,
			type:"curl",
			status:{open:false},
			pos:[240,270]
		}
	]

	$scope.selectedSatellites = $scope.satellites

	$scope.typeCommand = ->
		angular.forEach $scope.selectedSatellites, (entry) ->
			if entry.name.toLowerCase().indexOf($scope.command.name.toLowerCase()) == 0
				entry.visible = true
			else
				entry.visible = false

	$scope.changeState = (index) ->
		satellite = $scope.satellites[index]
		if(satellite.status.open)
			$resource(satellite.openUrl).get()
		else
			$resource(satellite.closeUrl).get()
	

	$timeout(( testFunkt = () ->
		$scope.satellites.forEach (satellite) ->
			if satellite.checkUrl
				$resource(satellite.checkUrl).get({},(satellite) ->
					angular.forEach $scope.selectedSatellites, (entry) ->
						if entry.name.toLowerCase().indexOf(satellite.hostname.toLowerCase()) == 0
							entry.status.open = satellite.status == "online"
				)
				$timeout(testFunkt, 500)
		),
		500
	);


