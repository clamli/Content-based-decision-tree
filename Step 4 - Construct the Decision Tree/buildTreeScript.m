dtmodel = ContentDecisionTree();
dtmodel.setSimilarityParams(1,1,1,1,1);
dtmodel.setDepthThreshold(10);
dtmodel.init();
dtmodel.buildTree();