//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Jason on 1/31/18.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //unhide Nav and Tab Bars
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
        
        //load Table with memes data
        tableView!.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(Meme.count())
        return Meme.count()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Percent of height
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppModel.memesTableCellReuseIdentifier, for: indexPath) as! SentMemesTableViewCell
        let meme = Meme.getMemeStorage().memes[indexPath.row]
        cell.updateCell(meme)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //get selected object
        let memeDetail = self.storyboard?.instantiateViewController(withIdentifier: AppModel.memeDetailStoryboardIdentifier) as! MemeDetailViewController
        //populate the meme data from selected row
        memeDetail.meme = Meme.getMemeStorage().memes[indexPath.row]
        //MemeDetail
        navigationController?.pushViewController(memeDetail, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            Meme.getMemeStorage().memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            return
        }
    }
    @IBAction func unwindToSentMemeTable(unwindSegue: UIStoryboardSegue) {
        
        //Learning from https://spin.atomicobject.com/2014/10/25/ios-unwind-segues/
        
    }
}
