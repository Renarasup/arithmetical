//
//  PlayViewController.swift
//  arithmetical
//
//  Created by Pedro Sandoval Segura on 8/4/16.
//  Copyright © 2016 Sandoval Software. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let games = Games.allGames
    var chosenGame: Game?
    var selectedIndexPath: IndexPath?
    var option: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Games"
        
        //Setup table view
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectedTimedGame(_ sender: AnyObject) {
        //Figure out which cell was tapped
        let buttonPosition: CGPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let selectedGame = self.games[(indexPath! as NSIndexPath).row]
        
        configureSelectedGame(game: selectedGame, as: "timed")
    }
    
    @IBAction func selectedUnlimitedGame(_ sender: AnyObject) {
        //Figure out which cell was tapped
        let buttonPosition: CGPoint = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let selectedGame = self.games[(indexPath! as NSIndexPath).row]
        
        configureSelectedGame(game: selectedGame, as: "unlimited")
    }
    
    func configureSelectedGame(game: Game, as option: String) {
        //Check what type of game was selected
        if let arithmeticGame = game as? ArithmeticGame {
            self.chosenGame = arithmeticGame
            self.option = option
            self.performSegue(withIdentifier: "toArithmeticGame", sender: nil)
        } else if let answerGame = game as? AnswerGame {
            self.chosenGame = answerGame
            self.option = option
            self.performSegue(withIdentifier: "toAnswerGame", sender: nil)
        } else if let dragGame = game as? DragGame {
            self.chosenGame = dragGame
            self.option = option
            self.performSegue(withIdentifier: "toDragGame", sender: nil)
        } else if let buttonGame = game as? ButtonGame {
            self.chosenGame = buttonGame
            self.option = option
            self.performSegue(withIdentifier: "toButtonGame", sender: nil)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = self.games[(indexPath as NSIndexPath).row]
        
        var cell: GameTableViewCell!
        if indexPath == selectedIndexPath {
            cell = self.tableView.dequeueReusableCell(withIdentifier: "selectedGameCell") as! GameTableViewCell
            cell.descriptionLabel.text = game.instructions!
            cell.gameImageView?.image = game.selectionImage!
        } else {
            cell = self.tableView.dequeueReusableCell(withIdentifier: "gameCell") as! GameTableViewCell
            cell.descriptionLabel.text = game.summary!
            cell.gameImageView?.image = game.image!

        }
        
        //Properties of both selected and regular cells
        cell.gameLabel.text = game.name!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var previousSelection: IndexPath?
        
        //Update the selected indexPath to shrink or expand the size of the game cell
        switch selectedIndexPath {
        case nil:
            //If no cell has been selected before, save the indexPath
            selectedIndexPath = indexPath
        default:
            if selectedIndexPath == indexPath {
                //If the same row was selected, remove the saved indexPath
                selectedIndexPath = nil
            } else {
                //Save the previously selected index path
                previousSelection = selectedIndexPath
                //If a new cell is tapped, save this new indexPath
                selectedIndexPath = indexPath
            }
        }
        
        
        //Refresh selected and previously selected cells
        tableView.reloadRows(at: [indexPath], with: .automatic)
        if let previousIndexPath = previousSelection {
            tableView.reloadRows(at: [previousIndexPath], with: .automatic)
        }
        

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedIndexPath == indexPath {
            return 220
        } else {
            return 98
        }
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //Segue to the corresponding game view controller
        if segue.identifier == "toArithmeticGame" {
            let arithmeticVC = segue.destination as! ArithmeticGamePlayViewController
            arithmeticVC.game = self.chosenGame as! ArithmeticGame
            arithmeticVC.option = self.option
        } else if segue.identifier == "toAnswerGame" {
            let answerVC = segue.destination as! AnswerGamePlayViewController
            answerVC.game = self.chosenGame as! AnswerGame
            answerVC.option = self.option
        } else if segue.identifier == "toDragGame" {
            let dragVC = segue.destination as! DragGamePlayViewController
            dragVC.game = self.chosenGame as! DragGame
            dragVC.option = self.option
        } else if segue.identifier == "toButtonGame" {
            let buttonVC = segue.destination as! ButtonGamePlayViewController
            buttonVC.game = self.chosenGame as! ButtonGame
            buttonVC.option = self.option
        }
    }
    

}
