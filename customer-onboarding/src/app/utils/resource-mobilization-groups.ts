import { ResourceMobilizationRecord } from '../models/onboarding.models';

export interface ResourceMobilizationRecordGroup {
  groupReference: string;
  primaryRecord: ResourceMobilizationRecord;
  records: ResourceMobilizationRecord[];
  status: string;
  isJointRegistration: boolean;
  jointParticipantCount: number;
  participantNames: string[];
  participantReferences: string[];
  employeeDisplayName: string;
  sourceTransactionAmount: number;
  splitAmountTotal: number;
  completedAt?: string | null;
}

export function groupResourceMobilizationRecords(records: ResourceMobilizationRecord[]): ResourceMobilizationRecordGroup[] {
  const groups = new Map<string, ResourceMobilizationRecord[]>();

  (records || []).forEach((record) => {
    const key = (record.registrationBatchReference || record.registrationReference || '').trim() || `ROW-${record.id}`;
    const items = groups.get(key) || [];
    items.push(record);
    groups.set(key, items);
  });

  return Array.from(groups.entries())
    .map(([groupReference, items]) => {
      const sortedItems = [...items].sort((left, right) => {
        const leftSeq = Number(left.jointSequenceNumber || 0);
        const rightSeq = Number(right.jointSequenceNumber || 0);
        if (leftSeq !== rightSeq) {
          return leftSeq - rightSeq;
        }

        return left.id - right.id;
      });

      const primaryRecord = sortedItems[0];
      const splitAmountTotal = sortedItems.reduce((sum, item) => sum + Number(item.totalDepositMobilized || 0), 0);
      const sourceTransactionAmount = Number(primaryRecord.sourceTransactionAmount || 0) || splitAmountTotal;
      const participantNames = sortedItems.map((item) => item.employeeFullName);
      const participantReferences = sortedItems.map((item) => item.employeeReference);
      const jointParticipantCount = Math.max(Number(primaryRecord.jointParticipantCount || 0), sortedItems.length, 1);
      const isJointRegistration = !!primaryRecord.isJointRegistration || jointParticipantCount > 1;
      const employeeDisplayName = isJointRegistration
        ? `${primaryRecord.employeeFullName} +${jointParticipantCount - 1}`
        : primaryRecord.employeeFullName;

      return {
        groupReference,
        primaryRecord,
        records: sortedItems,
        status: primaryRecord.status,
        isJointRegistration,
        jointParticipantCount,
        participantNames,
        participantReferences,
        employeeDisplayName,
        sourceTransactionAmount,
        splitAmountTotal,
        completedAt: primaryRecord.approvedAt || primaryRecord.rejectedAt || primaryRecord.updatedAt
      } as ResourceMobilizationRecordGroup;
    })
    .sort((left, right) => {
      const leftTime = new Date(left.completedAt || left.primaryRecord.createdAt).getTime();
      const rightTime = new Date(right.completedAt || right.primaryRecord.createdAt).getTime();
      return rightTime - leftTime;
    });
}
