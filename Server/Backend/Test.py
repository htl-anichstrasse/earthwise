#import ArrangeDataForWebsite as ad
#import DatabaseInserts.DataForDatabase as d
#import json

def testDataForDatabase():
    da = d.data
    da1 = da[1]
    da1name = da1["name"]
    #print("name:" + da1name)
    
    alleNamen = []
    x = 0
    for i in da:
        a = i["name"]
        alleNamen.append(a["common"])
        x = x+1
        
    alleNamen = sorted(alleNamen)
    print(alleNamen)
    print("\n \n \n" + str(x))
    
    alleNamen2 = []
    x2 = 0
    for i in da:
        if "independent" in i:
            v = i["independent"]
            if v:
                a = i["name"]
                alleNamen2.append(a["common"])
                x2 = x2+1
        else:
            print("\n \n \n")
            print(i["name"])
        
    alleNamen2 = sorted(alleNamen2)
    print(alleNamen2)
    print("\n \n \n" + str(x2))
    pass

if __name__ == '__main__':
    #answer = ad.get_quiz_overview()
    #print(answer)
    #da = d.data
    #allKeys = []
    #for i in da:
    #    a = i.keys()
    #    for x in a:
    #        if x in allKeys:
    #            pass
    #        else:
    #            allKeys.append(x)
    #            
    #print(allKeys)
    dicttest = {"hallo": "hallo"}
    dicttest.update({"hallo2": "hallo2"})
    print(dicttest)