// import MapView from './maps/MapView'
// import Marker from './maps/Marker'
// import Polygon from './maps/Polygon'
// import Circle from './maps/Circle'
import { Map, Marker as RMarker } from 'react-amap';


const MapView = (props) => {
  return <Map {...props} center={props.coordinate}></Map>
}
const Marker = (props) => {
  return <RMarker {...props} center={props.coordinate} />
}
MapView.Marker = Marker
export default MapView
export {
  MapView,
  Marker,
}
