//
//  ViewControllerGraph.swift
//  WeatherApp
//
//  Created by lösen är 0000 on 2018-03-31.
//  Copyright © 2018 TobiasJohansson. All rights reserved.
//

import UIKit
import Charts

class ViewControllerGraph: UIViewController, ChartViewDelegate {
    var cityArray: [CityWeather]!
    @IBOutlet weak var graphView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView.delegate = self
        setupGraph()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupGraph() {
        graphDesign()
        insertData()
        animateGraph()
    }
    
    func graphDesign() {
        graphView.chartDescription?.text = ""
        graphView.xAxis.granularity = 1
        graphView.xAxis.enabled = false
        graphView.rightAxis.addLimitLine(ChartLimitLine(limit: 0, label: "Zero"))
        graphView.legend.font = .systemFont(ofSize: 15)
        graphView.leftAxis.labelFont = graphView.legend.font
        graphView.rightAxis.labelFont = graphView.legend.font
        graphView.scaleXEnabled = false
        graphView.scaleYEnabled = false
        
        
    }
    
    func insertData() {
        var dataSets: [BarChartDataSet] = []
        let colors = ChartColorTemplates.colorful()
        for i in 0..<cityArray.count {
            let dataEntry = [BarChartDataEntry(x: Double(i), yValues: [0, Double(cityArray[i].temp)])]
            let dataSet = BarChartDataSet(values: dataEntry, label: cityArray[i].name)
            dataSet.setColors(colors[i])
            dataSet.valueFont = .systemFont(ofSize: 15)
            dataSets.append(dataSet)
            
        }
        let charData = BarChartData(dataSets: dataSets)
        graphView.data = charData
    }
    
    func animateGraph(){
        graphView.animate(xAxisDuration: 2, yAxisDuration: 2)
    }
    //Todo Appen crashar eftersom det bara kan vara 5 färger
    //Todo dynamics och animate
}
