#Use the RTI Scheduler Files from the Team content\_Shared Data File Reports\RTI Scheduler Files? If $False then you need them in your My Content folder in "RTI Scheduler Files"
$SharedCognosFolder = $True

#Token provided by RTI
$RTIToken = 'OQPQnKZI1hpLonU6xMxSAL5mxEaxO2yjCheDtidg'

#Building Names and Numbers. The building number must match the exact name in eSchool. Check your schools.csv from Clever. (Will also be downloaded on first run.)
$rti_building_numbers = @{
    'My Primary School' = 34399971
    'My Elementary School'= 34399972
    'My Middle School' = 34399973
    'My High School' = 34399974
}