//
//  OwnerCompletedJobCell.swift
//  Demo
//
//  Created by Pradeep Chakoriya on 17/09/15.
//  Copyright (c) 2015 Pradeep Chakoriya Ltd All rights reserved.
//

import Foundation
import UIKit
class OwnerCompletedJobCell: UITableViewCell {
    
    
    @IBOutlet weak var lblStatus        : UILabel!
    @IBOutlet weak var lblHiredPerson   : UILabel!
    @IBOutlet weak var bgVIew           : UIView!

    @IBOutlet weak var lblToTIme        : UILabel!
    @IBOutlet weak var lblFromTime      : UILabel!
    @IBOutlet weak var lblTitle         : UILabel!
    
    @IBOutlet weak var lblDuration      : UILabel!
    @IBOutlet weak var lblPosted        : UILabel!
    
    
    //Cell configuration
    func configureForItem( job: OwnerCompletedJobs ) {
        
        lblTitle.text       = ""
        lblPosted.text      = ""
        lblDuration.text    = ""
        lblFromTime.text    = ""
        lblToTIme.text      = ""
        
        lblTitle.text               = "Job #: " + job.title
        lblPosted.text              = job.getPostedDate()
        lblDuration.text            = job.getDurationDate()
        lblFromTime.text            = job.from
        lblToTIme.text              = job.to
        lblHiredPerson.text         = job.hiredPharmacist
        lblHiredPerson.textColor    = colors.kSkyColor
        
        self.selectionStyle         = .None
        bgVIew.layer.cornerRadius   = 4.0
        bgVIew.layer.borderColor    = colors.KBalckTextColor.CGColor
        bgVIew.layer.borderWidth    = 1.0
        
       
    }
}
