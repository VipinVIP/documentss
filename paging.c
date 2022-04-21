#include <stdio.h>
#include <stdlib.h>

struct page_table_entry {
  int frame_no;
  int valid;
};

int main() {

  struct page_table_entry *page_table_base[10];
  int number, entries, i, j, pid, logical_address, index, offset, choice;

  printf("\n Enter the number of processes : ");
  scanf("%d", &number);

  for (i = 0; i < number; i++) {

    page_table_base[i] =
        (struct page_table_entry *)malloc(16 * sizeof(struct page_table_entry));

    printf("\n Process %d \n Enter the numberof valid entries : ", i + 1);
    scanf("%d", &entries);

    for (j = 0; j < 16; j++) {

      if (j < entries) {

        printf("\n Enter the %dth frame number for %dth process : ", j + 1,
               i + 1);
        scanf("%d", &page_table_base[i][j].frame_no);
        page_table_base[i][j].valid = 1;
      }

      else {

        page_table_base[i][j].valid = 0;
      }
    }
  }

  while (1) {

    printf("\n-------MENU-------\n\n");
    printf("1.Schedule\n2.Translate\n3.Exit\n\nEnter your choice : ");
    scanf("%d", &choice);

    switch (choice) {
    case 1:
      printf("\nEnter the page table to be used : ");
      scanf("%d", &pid);
      pid--;
      if (pid >= number || pid <0) {
      printf("\n no page table for this process\n");
      }
      break;
    case 2:
      if (pid < number) {
        printf("\nEnter logical address in hexadecimal : ");
        scanf("%x", &logical_address);
        index = logical_address / 4096;
        offset = logical_address % 4096;
        if (page_table_base[pid][index].valid == 1) {
          printf("physical_address = %x\n",
                 (page_table_base[pid][index].frame_no) * 4096 + offset);

          printf("\nindex\tframe_no\tvalid\n");
          for (int m = 0; m <16; m++) {
            printf("%3d\t%8d\t%3d\n", m, page_table_base[pid][m].frame_no, page_table_base[pid][m].valid);
          }
        } else {
          printf("\ninvalid frame\n");
        }
      } else {
        printf("\n no page table selected\n");
      }
      break;
    case 3:
      return 0;
    default:
      return 0;
    }
  }

  return 0;
}
