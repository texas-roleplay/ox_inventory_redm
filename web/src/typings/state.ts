import { Inventory } from './inventory';

export type State = {
  leftInventory: Inventory;
  rightInventory: Inventory;
  itemAmount: number;
  shiftPressed: boolean;
  ctrlPressed: boolean;
  isBusy: boolean;
  history?: {
    leftInventory: Inventory;
    rightInventory: Inventory;
  };
};
