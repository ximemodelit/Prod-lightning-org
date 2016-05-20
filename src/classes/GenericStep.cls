public with sharing class GenericStep {
		public String Id { get; set; }
		public String TaskName { get; set; }
		public String PredecessorIds { get; set; }
		public String Sequence { get; set; }

		public GenericStep() {}
		
		public GenericStep(String id, String taskName, String sequence, String predecessorIds) {
			this.Id = id;
			this.TaskName = taskName;
			this.Sequence = sequence;
			this.PredecessorIds = predecessorIds;
		}

}