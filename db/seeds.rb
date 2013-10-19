# encoding: utf-8
Profile.delete_all

profile = Profile.create(title: "DongXi Tech",
                         description: "DONGXI TECH 由来自Berkeley的Jiahao Li，圣三一学院的Water，和来自Sun Yat-sen Univ的Allen Wu倾情打造（说的很高端似的……）\n我们主要的想法就是做一个东西。\n 暂时是这个。",
                         sponsor: "Nike",
                         video: "<iframe height=498 width=510 src='http://player.youku.com/embed/XNDQ3NTQ5ODQ4' frameborder=0 allowfullscreen></iframe>")
