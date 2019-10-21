//
//  ViewController.swift
//  Onde Estou
//
//  Created by Matheus Rodrigues Araujo on 18/10/19.
//  Copyright © 2019 Curso IOS. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var velocidadeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var enderecoLabel: UILabel!
    
    
    var gerenciadorLocalizacao = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let localizacaoUsuario = locations.last!
        
        let latitude = localizacaoUsuario.coordinate.latitude
        let longitude = localizacaoUsuario.coordinate.longitude
        
        //--- Exibe o local atual do usuário e centra o mapa nesse local
        let localizacao = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let deltaLatitude: CLLocationDegrees = 0.01
        let deltaLongitude: CLLocationDegrees = 0.01
        let areaVisualizacao : MKCoordinateSpan = MKCoordinateSpan( latitudeDelta: deltaLatitude,  longitudeDelta: deltaLongitude)
        
        let regiao: MKCoordinateRegion = MKCoordinateRegion(center: localizacao, span: areaVisualizacao)
        
        mapa.setRegion(regiao, animated: true)
        //---
        
        latitudeLabel.text = String( latitude )
        longitudeLabel.text = String( longitude )
        if localizacaoUsuario.speed > 0 {
            velocidadeLabel.text = String ( localizacaoUsuario.speed )
        }
        //recuperar o endereco do usuário
        
        CLGeocoder().reverseGeocodeLocation(localizacaoUsuario) { (detalhesLocal, erro) in
            
            if erro == nil {
                
                if let dadosLocal = detalhesLocal?.first {
                    var throughtfare = ""
                    if dadosLocal.thoroughfare != nil {
                        throughtfare = dadosLocal.thoroughfare!
                    }
                    var subThoroughfare = ""
                    if dadosLocal.subThoroughfare != nil {
                        subThoroughfare = dadosLocal.subThoroughfare!
                    }
                    var locality = ""
                    if dadosLocal.locality != nil {
                        locality = dadosLocal.locality!
                    }
                    var subLocality = ""
                    if dadosLocal.subLocality != nil {
                        subLocality = dadosLocal.subLocality!
                    }
                    var postalCode = ""
                    if dadosLocal.postalCode != nil {
                        postalCode = dadosLocal.postalCode!
                    }
                    var country = ""
                    if dadosLocal.country != nil {
                        country = dadosLocal.country!
                    }
                    var administrativeArea = ""
                    if dadosLocal.administrativeArea != nil {
                        administrativeArea = dadosLocal.administrativeArea!
                    }
                    var subAdministrativeArea = ""
                    if dadosLocal.subAdministrativeArea != nil {
                        subAdministrativeArea = dadosLocal.subAdministrativeArea!
                    }
                    
                    self.enderecoLabel.text = throughtfare + "-" + subThoroughfare + "-" + locality + "-" + country
                    
                    print(  "\n / throughtfare:" +  throughtfare +
                            "\n / subThoroughfare:" + subThoroughfare +
                            "\n / locality:" + locality +
                            "\n / subLocality:" + subLocality +
                            "\n / postalCode:" + postalCode +
                            "\n / country:" + country +
                            "\n / administrativeArea:" + administrativeArea +
                            "\n / subAdministrativeArea:" + subAdministrativeArea
                    )
                
            } else {
                //acobnteceu erro e nao foi possivel recuperar o endereco
                print(erro)
            }
        }
        
    }
    
    
    // abre a janela de configuracao do dispositivo para que o usuario habilite a permissao necessária
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse {
            
            let alertaController = UIAlertController(title: "Permissão de localização", message: "Necessário permissão para acesso à sua localização! Por favor, habilite!", preferredStyle: .alert)
            let acaoConfiguracoes = UIAlertAction(title: "Abrir Configurações", style: .default, handler: {
                (alertaConfiguracoes) in
                
                if let configuracoes = NSURL(string: UIApplication.openSettingsURLString ) {
                    UIApplication.shared.open(configuracoes as URL)
                }
            })
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil )
            
            alertaController.addAction(acaoConfiguracoes)
            alertaController.addAction(acaoCancelar)
            
            present( alertaController, animated: true, completion: nil)
        }
    }
}

}
