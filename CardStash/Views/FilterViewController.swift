//
//  FilterViewController.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/24/25.
//

import Foundation
import UIKit

class FilterViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var typeFilter: UIButton!
    @IBOutlet weak var weaknessFilter: UIButton!
    @IBOutlet weak var resistanceFilter: UIButton!
    @IBOutlet weak var stageFilter: UIButton!
    @IBOutlet weak var cardTypeFilter: UIButton!
    @IBOutlet weak var retreatCostFilter: UIButton!
    @IBOutlet weak var holoFilter: UIButton!
    @IBOutlet weak var rarityFilter: UIButton!
    @IBOutlet weak var legalityFilter: UIButton!
    @IBOutlet weak var cardSetPicker: UIPickerView!
    
    // MARK: Variables
    
    private let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cardSetPicker.delegate = self
        cardSetPicker.dataSource = self
        cardSetPicker.tintColor = .white
        
        configureFilterButton()
        configureWeaknessButton()
        configureResistanceButton()
        
        configureRetreatCostButton()
        configureStageButton()
        configureCardTypeButton()
        
        configureHoloButton()
        configureRarityButton()
        configureLegalityButton()
        
        viewModel.getCardSets(completion: { [weak self] in
            DispatchQueue.main.async {
                self?.cardSetPicker.reloadAllComponents()
            }
        })
    }
    
    // MARK: Custom functions
    
    func configureFilterButton() {
        let anyFilter = { [unowned self] (action: UIAction) in
            self.viewModel.setTypeFilter(kind: .any)
        }
        
        let colorlessFilter = { [unowned self] (action: UIAction) in
            self.viewModel.setTypeFilter(kind: .colorless)
        }
        
        let fireFilter = { [unowned self] (action: UIAction) in
            self.viewModel.setTypeFilter(kind: .fire)
        }
        
        let lightningFilter = { [unowned self] (action: UIAction) in
            self.viewModel.setTypeFilter(kind: .lightning)
        }
        
        let grassFilter = { [unowned self] (action: UIAction) in
            self.viewModel.setTypeFilter(kind: .grass)
        }
        
        let waterFilter = { [unowned self] (action: UIAction) in
            self.viewModel.setTypeFilter(kind: .water)
        }
        
        let psychicFilter = { [unowned self] (action: UIAction) in
            self.viewModel.setTypeFilter(kind: .psychic)
        }
        
        let darknessFilter = { [unowned self] (action: UIAction) in
            self.viewModel.setTypeFilter(kind: .darkness)
        }
        
        let fairyFilter = { [unowned self] (action: UIAction) in
            self.viewModel.setTypeFilter(kind: .fairy)
        }
        
        let dragonFilter = { [unowned self] (action: UIAction) in
            self.viewModel.setTypeFilter(kind: .dragon)
        }
        
        let metalFilter = { [unowned self] (action: UIAction) in
            self.viewModel.setTypeFilter(kind: .metal)
        }
        
        let fightingFilter = { [unowned self] (action: UIAction) in
            self.viewModel.setTypeFilter(kind: .fighting)
        }
        
        typeFilter.menu = UIMenu(children: [
            UIAction(title: "Any", handler: anyFilter),
            UIAction(title: "Colorless", handler: colorlessFilter),
            UIAction(title: "Fire", handler: fireFilter),
            UIAction(title: "Lightning", handler: lightningFilter),
            UIAction(title: "Grass", handler: grassFilter),
            UIAction(title: "Water", handler: waterFilter),
            UIAction(title: "Psychic", handler: psychicFilter),
            UIAction(title: "Darkness", handler: darknessFilter),
            UIAction(title: "Fairy", handler: fairyFilter),
            UIAction(title: "Dragon", handler: dragonFilter),
            UIAction(title: "Metal", handler: metalFilter),
            UIAction(title: "Fighting", handler: fightingFilter)
        ])
    }
    
    func configureWeaknessButton() {
        let anyWeakness = { [unowned self] (action: UIAction) in
            self.viewModel.setWeaknessFilter(kind: .any)
        }
        
        let colorlessWeakness = { [unowned self] (action: UIAction) in
            self.viewModel.setWeaknessFilter(kind: .colorless)
        }
        
        let fireWeakness = { [unowned self] (action: UIAction) in
            self.viewModel.setWeaknessFilter(kind: .fire)
        }
        
        let lightningWeakness = { [unowned self] (action: UIAction) in
            self.viewModel.setWeaknessFilter(kind: .lightning)
        }
        
        let grassWeakness = { [unowned self] (action: UIAction) in
            self.viewModel.setWeaknessFilter(kind: .grass)
        }
        
        let waterWeakness = { [unowned self] (action: UIAction) in
            self.viewModel.setWeaknessFilter(kind: .water)
        }
        
        let psychicWeakness = { [unowned self] (action: UIAction) in
            self.viewModel.setWeaknessFilter(kind: .psychic)
        }
        
        let darknessWeakness = { [unowned self] (action: UIAction) in
            self.viewModel.setWeaknessFilter(kind: .darkness)
        }
        
        let fairyWeakness = { [unowned self] (action: UIAction) in
            self.viewModel.setWeaknessFilter(kind: .fairy)
        }
        
        let dragonWeakness = { [unowned self] (action: UIAction) in
            self.viewModel.setWeaknessFilter(kind: .dragon)
        }
        
        let metalWeakness = { [unowned self] (action: UIAction) in
            self.viewModel.setWeaknessFilter(kind: .metal)
        }
        
        let fightingWeakness = { [unowned self] (action: UIAction) in
            self.viewModel.setWeaknessFilter(kind: .fighting)
        }
        
        weaknessFilter.menu = UIMenu(children: [
            UIAction(title: "Any", handler: anyWeakness),
            UIAction(title: "Colorless", handler: colorlessWeakness),
            UIAction(title: "Fire", handler: fireWeakness),
            UIAction(title: "Lightning", handler: lightningWeakness),
            UIAction(title: "Grass", handler: grassWeakness),
            UIAction(title: "Water", handler: waterWeakness),
            UIAction(title: "Psychic", handler: psychicWeakness),
            UIAction(title: "Darkness", handler: darknessWeakness),
            UIAction(title: "Fairy", handler: fairyWeakness),
            UIAction(title: "Dragon", handler: dragonWeakness),
            UIAction(title: "Metal", handler: metalWeakness),
            UIAction(title: "Fighting", handler: fightingWeakness)
        ])
    }
    
    func configureResistanceButton() {
        let anyResistance = { [unowned self] (action: UIAction) in
            self.viewModel.setResistanceFilter(kind: .any)
        }
        
        let colorlessResistance = { [unowned self] (action: UIAction) in
            self.viewModel.setResistanceFilter(kind: .colorless)
        }
        
        let fireResistance = { [unowned self] (action: UIAction) in
            self.viewModel.setResistanceFilter(kind: .fire)
        }
        
        let lightningResistance = { [unowned self] (action: UIAction) in
            self.viewModel.setResistanceFilter(kind: .lightning)
        }
        
        let grassResistance = { [unowned self] (action: UIAction) in
            self.viewModel.setResistanceFilter(kind: .grass)
        }
        
        let waterResistance = { [unowned self] (action: UIAction) in
            self.viewModel.setResistanceFilter(kind: .water)
        }
        
        let psychicResistance = { [unowned self] (action: UIAction) in
            self.viewModel.setResistanceFilter(kind: .psychic)
        }
        
        let darknessResistance = { [unowned self] (action: UIAction) in
            self.viewModel.setResistanceFilter(kind: .darkness)
        }
        
        let fairyResistance = { [unowned self] (action: UIAction) in
            self.viewModel.setResistanceFilter(kind: .fairy)
        }
        
        let dragonResistance = { [unowned self] (action: UIAction) in
            self.viewModel.setResistanceFilter(kind: .dragon)
        }
        
        let metalResistance = { [unowned self] (action: UIAction) in
            self.viewModel.setResistanceFilter(kind: .metal)
        }
        
        let fightingResistance = { [unowned self] (action: UIAction) in
            self.viewModel.setResistanceFilter(kind: .fighting)
        }
        
        resistanceFilter.menu = UIMenu(children: [
            UIAction(title: "Any", handler: anyResistance),
            UIAction(title: "Colorless", handler: colorlessResistance),
            UIAction(title: "Fire", handler: fireResistance),
            UIAction(title: "Lightning", handler: lightningResistance),
            UIAction(title: "Grass", handler: grassResistance),
            UIAction(title: "Water", handler: waterResistance),
            UIAction(title: "Psychic", handler: psychicResistance),
            UIAction(title: "Darkness", handler: darknessResistance),
            UIAction(title: "Fairy", handler: fairyResistance),
            UIAction(title: "Dragon", handler: dragonResistance),
            UIAction(title: "Metal", handler: metalResistance),
            UIAction(title: "Fighting", handler: fightingResistance)
        ])
    }
    
    func configureRetreatCostButton() {
        let anyRetreatCost = { [unowned self] (action: UIAction) in
            self.viewModel.setRetreatCostFilter(amount: -1)
        }
        
        let noneRetreatCost = { [unowned self] (action: UIAction) in
            self.viewModel.setRetreatCostFilter(amount: 0)
        }
        
        let oneRetreatCost = { [unowned self] (action: UIAction) in
            self.viewModel.setRetreatCostFilter(amount: 1)
        }
        
        let twoRetreatCost = { [unowned self] (action: UIAction) in
            self.viewModel.setRetreatCostFilter(amount: 2)
        }
        
        let threeRetreatCost = { [unowned self] (action: UIAction) in
            self.viewModel.setRetreatCostFilter(amount: 3)
        }
        
        let fourRetreatCost = { [unowned self] (action: UIAction) in
            self.viewModel.setRetreatCostFilter(amount: 4)
        }
        
        let fiveRetreatCost = { [unowned self] (action: UIAction) in
            self.viewModel.setRetreatCostFilter(amount: 5)
        }
        
        retreatCostFilter.menu = UIMenu(children: [
            UIAction(title: "Any", handler: anyRetreatCost),
            UIAction(title: "0", handler: noneRetreatCost),
            UIAction(title: "1", handler: oneRetreatCost),
            UIAction(title: "2", handler: twoRetreatCost),
            UIAction(title: "3", handler: threeRetreatCost),
            UIAction(title: "4", handler: fourRetreatCost),
            UIAction(title: "5", handler: fiveRetreatCost)
        ])
    }
    
    func configureStageButton() {
        let anyStage = { [unowned self] (action: UIAction) in
            self.viewModel.setStageFilter(kind: .any)
        }
        
        let babyStage = { [unowned self] (action: UIAction) in
            self.viewModel.setStageFilter(kind: .baby)
        }
        
        let basicStage = { [unowned self] (action: UIAction) in
            self.viewModel.setStageFilter(kind: .basic)
        }
        
        let stage1Stage = { [unowned self] (action: UIAction) in
            self.viewModel.setStageFilter(kind: .stage1)
        }
        
        let stage2Stage = { [unowned self] (action: UIAction) in
            self.viewModel.setStageFilter(kind: .stage2)
        }
        
        stageFilter.menu = UIMenu(children: [
            UIAction(title: "Any", handler: anyStage),
            UIAction(title: "Baby", handler: babyStage),
            UIAction(title: "Basic", handler: basicStage),
            UIAction(title: "Stage 1", handler: stage1Stage),
            UIAction(title: "Stage 2", handler: stage2Stage)
        ])
    }
    
    func configureCardTypeButton() {
        let anyType = { [unowned self] (action: UIAction) in
            self.viewModel.setCardTypeFilter(kind: .any)
        }
        
        let pokemonType = { [unowned self] (action: UIAction) in
            self.viewModel.setCardTypeFilter(kind: .pokemon)
        }
        
        let energyType = { [unowned self] (action: UIAction) in
            self.viewModel.setCardTypeFilter(kind: .energy)
        }
        
        let trainerType = { [unowned self] (action: UIAction) in
            self.viewModel.setCardTypeFilter(kind: .trainer)
        }
        
        cardTypeFilter.menu = UIMenu(children: [
            UIAction(title: "Any", handler: anyType),
            UIAction(title: "Pokemon", handler: pokemonType),
            UIAction(title: "Energy", handler: energyType),
            UIAction(title: "Trainer", handler: trainerType)
        ])
    }
    
    func configureHoloButton() {
        let anyType = { [unowned self] (action: UIAction) in
            self.viewModel.setHoloFilter(kind: .any)
        }
        
        let holoType = { [unowned self] (action: UIAction) in
            self.viewModel.setHoloFilter(kind: .holo)
        }
        
        let notHoloType = { [unowned self] (action: UIAction) in
            self.viewModel.setHoloFilter(kind: .notHolo)
        }
        
        holoFilter.menu = UIMenu(children: [
            UIAction(title: "Any", handler: anyType),
            UIAction(title: "Holographic", handler: holoType),
            UIAction(title: "Not holographic", handler: notHoloType)
        ])
    }
    
    func configureRarityButton() {
        let anyType = { [unowned self] (action: UIAction) in
            self.viewModel.setRarityFilter(kind: .any)
        }
        
        let commonType = { [unowned self] (action: UIAction) in
            self.viewModel.setRarityFilter(kind: .common)
        }
        
        let uncommonType = { [unowned self] (action: UIAction) in
            self.viewModel.setRarityFilter(kind: .uncommon)
        }
        
        let rareType = { [unowned self] (action: UIAction) in
            self.viewModel.setRarityFilter(kind: .rare)
        }
        
        let promoType = { [unowned self] (action: UIAction) in
            self.viewModel.setRarityFilter(kind: .promo)
        }
        
        let legendType = { [unowned self] (action: UIAction) in
            self.viewModel.setRarityFilter(kind: .legend)
        }
        
        rarityFilter.menu = UIMenu(children: [
            UIAction(title: "Any", handler: anyType),
            UIAction(title: "Common", handler: commonType),
            UIAction(title: "Uncommon", handler: uncommonType),
            UIAction(title: "Rare", handler: rareType),
            UIAction(title: "Promo", handler: promoType),
            UIAction(title: "LEGEND", handler: legendType)
        ])
    }
    
    func configureLegalityButton() {
        let anyType = { [unowned self] (action: UIAction) in
            self.viewModel.setLegalityFilter(kind: .any)
        }
        
        let standardType = { [unowned self] (action: UIAction) in
            self.viewModel.setLegalityFilter(kind: .standard)
        }
        
        let expandedType = { [unowned self] (action: UIAction) in
            self.viewModel.setLegalityFilter(kind: .expanded)
        }
        
        let unlimitedType = { [unowned self] (action: UIAction) in
            self.viewModel.setLegalityFilter(kind: .unlimited)
        }
        
        legalityFilter.menu = UIMenu(children: [
            UIAction(title: "Any", handler: anyType),
            UIAction(title: "Standard", handler: standardType),
            UIAction(title: "Expanded", handler: expandedType),
            UIAction(title: "Unlimited", handler: unlimitedType)
        ])
    }
}

extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.getCardSetCount()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.getCardSetTitle(index: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.setSelectedCardSet(index: row)
    }
}
