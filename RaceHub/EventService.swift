//
//  EventStore.swift
//  RaceHub
//
//  Created by Piotr Olejnik on 01.09.2017.
//  Copyright © 2017 gat. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

protocol EventService {
    func events(within radius: Double, from location: CLLocation, with types: [EventType], from: Date, to: Date) -> Observable<[Event]>
    func events(for query: String) -> Observable<[Event]>
    func eventDetails(with id: Int) -> Observable<EventDetails>
}

struct EventServiceImpl: EventService {
    
    func eventDetails(with id: Int) -> Observable<EventDetails> {
        return Observable<EventDetails>.create { observer -> Disposable in
            Utilities.delayWithSeconds(2.0, completion: {
                observer.onNext(self.testEvent())
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    func events(within radius: Double, from location: CLLocation, with types: [EventType], from: Date, to: Date) -> Observable<[Event]> {
        return Observable<[Event]>.create { observer -> Disposable in
            Utilities.delayWithSeconds(2.0, completion: {
                observer.onNext(self.allEvents().filter { types.contains($0.type) && $0.distance(from: location) <= radius && $0.date >= from && $0.date <= to })
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }

    func events(for query: String) -> Observable<[Event]> {
        return Observable<[Event]>.create { observer -> Disposable in
            Utilities.delayWithSeconds(2.0) {
                observer.onNext(self.allEvents().filter { $0.name.lowercased().contains(query.lowercased()) })
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    private func testEvent() -> EventDetails {
        let event = EventDetails()
        event.name = "Festiwal Biegowy"
        event.city = "Krynica"
        event.date = DateProviderImpl().parse("2017-09-08 09:00:00")
        event.image = "http://www.festiwalbiegowy.pl/sites/default/files/styles/obrazek_tresc_590/public/FB-graf.jpg"
        event.eventId = 1
        event.desc = "PKO Festiwal Biegowy to jedna z największych i najwszechstronniejsza impreza biegowa w Polsce i Europie Środkowo-Wschodniej. W 2017 roku spotykamy się w pierwszy pełny tydzień września. Zapraszamy dzieci, początkujących, ambitnych i profesjonalnych biegaczy. Biegaczy ulicznych i górskich, średniodystansowców i ultrasów. Stałych bywalców biegów w Krynicy jak i debiutantów.\n\nSportowy program imprezy w 2017 r. obejmie już ponad 30 biegów i marszów, na dystansach od 300m do 100 km, a łączna długość tras przekroczy 300 km. Najbardziej prestiżowe konkurencje Festiwalu to Bieg 7 Dolin na trzech dystansach – 34, 64 i 100 km, Życiowa Dziesiątka, Koral Maraton i Półmaraton, Bieg na Jaworzynę czy biegowa etapówka Iron Run. Najweselsze starty to z kolei Bieg Przebierańców, Bieg Kibica czy Bieg z krawatem, choć i tu do zdobycia są pamiątkowe medale i nagrody.\n\nPonownie dajemy Wam możliwość wyboru zawartości pakietu startowego. W podstawowej wersji, którą uwzględnia opłata startowa, znajdą się numer startowy z chipem, worek biegacza, woda oraz upominki i kupony rabatowe od partnerów 8. PKO Festiwalu Biegowego. Wasz pakiet Premium może zawierać festiwalową koszulkę techniczną, chustę wielofunkcyjną, zestaw opasek na rękę oraz inne ciekawe gadżety, które możecie sprawdzić TUTAJ - wystarczy zaznaczyć odpowiednią opcję w formularzu zgłoszeniowym."
        let distance1 = RaceDistance()
        distance1.desc = "Bieg ultramaratoński, dedykowany doświadczonym biegaczom, z doświadczeniem w biegach górskich. Bieg jest eliminacją Ultra-Trail du Mont-Blanc® w edycji 2018.\n\nMountain ultramarathon for experienced runners. Ultra-Trail du Mont-Blanc® 2017 qualifier.\n\n\nTrasa: 100 km\n\n\nTrasa certyfikowana przez ITRA. Trudna, wyznaczona w Beskidzie Sądeckim, górzysta z licznymi podbiegami i zbiegami, możliwe wiatrołomy. Przewyższenia +/-4500m. Szczegóły w mapie dołączonej do pakietu startowego.\n\nChallenging course in Beskid Sadecki region, with climbs and downhills. Elevation +/-4500m. ITRA certifiication."
        distance1.rules = "Limity czasu / Time limits:\n\nRytro 36 km – 5h30'\nPiwniczna Zdrój 66 km – 11h30'\nWierchomla 77 km – 13h\nBacówka nad Wierchomlą 88 km – 15h\nKrynica-Zdrój 100 km (meta / finish) – 17h\n\nWyposażenie obowiązkowe / Obligatory equipment\n\nnaładowany telefon komórkowy z numerem ICE / cell phone with ICE numer\nlatarka (czołówka) na pierwszy etap (Krynica- Rytro) i ostatni (Wierchomla- Krynica) / light or torch for the first and ultimate stage\nmapa trasy z pakietu startowego / course map received with bib\nKażdy z uczestników biegu musi posiadać podstawowe ubezpieczenie zdrowotne. Nie ma obowiązku posiadania przy sobie dokumentu potwierdzającego to ubezpieczenie. Organizator nie zapewnia dodatkowego ubezpieczenia NNW – uczestnicy mogą je wykupić we własnym zakresie."
        distance1.name = "Bieg 7 Dolin"
        distance1.startDate = DateProviderImpl().parse("2017-09-09 01:00:00")
        distance1.distance = 100000
        distance1.hourLimit = 17
        event.distances.append(distance1)
        return event
    }
    
    private func allEvents() -> [Event] {
        let bike = Event()
        bike.id = 0
        bike.name = "test rower"
        bike.type = .bike
        bike.latitude = 50.664177
        bike.longitude = 16.539263
        let run = Event()
        run.id = 1
        run.type = .run
        run.name = "test bieg"
        run.latitude = 50.866922
        run.longitude = 16.712602
        let tri = Event()
        tri.id = 2
        tri.type = .multisport
        tri.name = "test triathlon"
        tri.latitude = 50.969889
        tri.longitude = 16.629849
        return [bike, run, tri]
    }
    
}
